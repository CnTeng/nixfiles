{ config, lib, ... }:
with lib;
let
  server = config.services'.tuic-server;
  client = config.services'.tuic-client;
  port = 443;
in {
  options.services' = {
    tuic-server.enable = mkEnableOption' { };
    tuic-client.enable = mkEnableOption' { };
  };

  config = mkIf (server.enable || client.enable) {
    networking.firewall.allowedUDPPorts = [ port ];

    sops.secrets = let
      units = optional server.enable "sing-box.service"
        ++ optional client.enable "dae.service";
    in {
      cf-dns01-token = {
        key = "outputs/cf_api_token/value";
        sopsFile = config.sops-file.infra;
        restartUnits = [ "sing-box.service" ];
      };

      tuic-ip = {
        key = "outputs/hosts/value/rxls0/ipv4";
        sopsFile = config.sops-file.infra;
        restartUnits = [ "dae.service" ];
      };

      "tuic/uuid" = {
        sopsFile = ./secrets.yaml;
        restartUnits = units;
      };

      "tuic/pass" = {
        sopsFile = ./secrets.yaml;
        restartUnits = units;
      };
    };

    services.sing-box = mkIf server.enable {
      enable = true;
      settings = {
        log.level = "info";
        inbounds = [{
          type = "tuic";
          listen = "::";
          listen_port = port;
          users = [{
            uuid._secret = config.sops.secrets."tuic/uuid".path;
            password._secret = config.sops.secrets."tuic/pass".path;
          }];
          congestion_control = "bbr";
          tls = {
            enabled = true;
            server_name = "tuic.snakepi.xyz";
            acme = {
              domain = "tuic.snakepi.xyz";
              email = "isyufei.teng@gmail.com";
              dns01_challenge = {
                provider = "cloudflare";
                api_token._secret = config.sops.secrets.cf-dns01-token.path;
              };
            };
          };
        }];
      };
    };

    sops.templates.dae-config = {
      content = ''
        global {
          wan_interface: auto
        }

        node {
          tuic: 'tuic://${config.sops.placeholder."tuic/uuid"}:${
            config.sops.placeholder."tuic/pass"
          }@${config.sops.placeholder.tuic-ip}:${
            toString port
          }?sni=tuic.snakepi.xyz&congestion_control=bbr'
        }

        dns {
          upstream {
            google: 'tcp+udp://dns.google.com:53'
            ali: 'udp://dns.alidns.com:53'
          }
          routing {
            request {
              fallback: ali
            }
            response {
              upstream(google) -> accept
              ip(geoip:private) && !qname(geosite:cn) -> google
              fallback: accept
            }
          }
        }

        group {
          proxy {
            policy: fixed(0)
          }
        }

        routing {
          pname(NetworkManager, ssh) -> must_direct

          dip(224.0.0.0/3, 'ff00::/8') -> direct
          dip(geoip:private) -> direct
          dip(geoip:cn) -> direct

          domain(geosite:category-ads) -> block
          domain(geosite:cn) -> direct

          fallback: proxy
        }
      '';
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
      "net.ipv4.conf.all.send_redirects" = false;
      "net.ipv4.ip_forward" = true;
    };

    services.dae = mkIf client.enable {
      enable = true;
      configFile = config.sops.templates.dae-config.path;
    };
  };
}
