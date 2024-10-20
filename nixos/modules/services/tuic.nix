{
  config,
  lib,
  pkgs,
  data,
  ...
}:
let
  inherit (config.services'.tuic) server client;
  inherit (config.networking) hostName;
  port = 1080;
in
{
  options.services'.tuic = {
    server.enable = lib.mkEnableOption' { };
    client.enable = lib.mkEnableOption' { };
  };

  config = lib.mkIf (server.enable || client.enable) {
    networking.firewall.allowedUDPPorts = [ port ];

    sops.secrets = {
      cf-dns01-token = lib.mkIf server.enable {
        key = "tokens/cf_cdntls";
        restartUnits = [ "sing-box.service" ];
      };

      "tuic/uuid" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };

      "tuic/pass" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };
    };

    services.sing-box = {
      enable = true;
      settings =
        let
          serverConfig = {
            inbounds = [
              {
                type = "tuic";
                listen = "::";
                listen_port = port;
                users = [
                  {
                    uuid._secret = config.sops.secrets."tuic/uuid".path;
                    password._secret = config.sops.secrets."tuic/pass".path;
                  }
                ];
                congestion_control = "bbr";
                tls = {
                  enabled = true;
                  server_name = "${hostName}.snakepi.xyz";
                  acme = {
                    domain = "${hostName}.snakepi.xyz";
                    email = "rxsnakepi@gmail.com";
                    dns01_challenge = {
                      provider = "cloudflare";
                      api_token._secret = config.sops.secrets.cf-dns01-token.path;
                    };
                  };
                };
              }
            ];
          };

          clientConfig = {
            dns = {
              servers = [
                {
                  tag = "google";
                  address = "https://8.8.8.8/dns-query";
                  address_resolver = "local";
                  detour = "proxy";
                }
                {
                  tag = "local";
                  address = "223.5.5.5";
                  detour = "direct";
                }
              ];
              rules = [
                {
                  rule_set = "geosite-cn";
                  server = "local";
                }
                {
                  outbound = "any";
                  server = "local";
                }
              ];
            };
            inbounds = [
              {
                type = "tun";
                interface_name = "tun0";
                address = [
                  "172.19.0.1/30"
                  "fdfe:dcba:9876::1/126"
                ];
                auto_route = true;
                strict_route = false;
              }
            ];
            outbounds = [
              {
                type = "tuic";
                server = data.hosts.lssg.ipv4;
                server_port = port;
                uuid._secret = config.sops.secrets."tuic/uuid".path;
                password._secret = config.sops.secrets."tuic/pass".path;
                congestion_control = "bbr";
                network = "tcp";
                tls = {
                  enabled = true;
                  server_name = "lssg.snakepi.xyz";
                };
                tag = "proxy";
              }
              {
                type = "direct";
                tag = "direct";
              }
              {
                type = "dns";
                tag = "dns-out";
              }
            ];
            route = {
              rules = [
                {
                  port = [ 53 ];
                  outbound = "dns-out";
                }
                {
                  ip_is_private = true;
                  outbound = "direct";
                }
                {
                  process_name = [ "ssh" ];
                  outbound = "direct";
                }
                {
                  rule_set = "geosite-cn";
                  outbound = "direct";
                }
                {
                  rule_set = "geoip-cn";
                  outbound = "direct";
                }
                {
                  protocol = "dns";
                  outbound = "dns-out";
                }
              ];
              rule_set = [
                {
                  type = "local";
                  tag = "geosite-cn";
                  format = "binary";
                  path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
                }
                {
                  type = "local";
                  tag = "geoip-cn";
                  format = "binary";
                  path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
                }
              ];
              auto_detect_interface = true;
            };
          };
        in
        {
          log.level = "info";
        }
        // lib.optionalAttrs server.enable serverConfig
        // lib.optionalAttrs client.enable clientConfig;
    };

    networking.firewall.trustedInterfaces = [ "tun0" ];
  };
}
