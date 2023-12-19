{ config, lib, pkgs, utils, user, ... }:
with lib;
let
  cfg = config.services'.dae;
  port = 1081;
in {
  options.services'.dae.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;
      config = ''
        global {
          wan_interface: auto
          auto_config_kernel_parameter: true
        }

        node {
          naive: 'socks://127.0.0.1:${toString port}'
        }

        dns {
          upstream {
            google: 'tcp+udp://dns.google.com:53'
            ali: 'udp://dns.alidns.com:53'
          }
          routing {
            request {
              qname(geosite:category-ads-all) -> reject
              qname(geosite:cn) -> ali
              fallback: google
            }
            response {
              upstream(google) -> accept
              !qname(geosite:cn) && ip(geoip:private) -> google
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
          pname(NetworkManager, naive, ssh) -> must_direct

          dip(geoip:private) -> direct
          dip(geoip:cn) -> direct
          dip(8.8.8.8, 8.8.4.4) -> direct
          dip(223.5.5.5, 223.6.6.6) -> direct
          dip(224.0.0.0/3, 'ff00::/8') -> direct

          domain(geosite:category-ads) -> block
          domain(geosite:cn) -> direct

          fallback: proxy
        }
      '';
    };
    systemd.services.dae.requires = [ "naiveproxy.service" ];

    systemd.services.naiveproxy = let
      settings = {
        listen = "socks://127.0.0.1:${toString port}";
        proxy._secret = config.sops.secrets."naive/client".path;
      };
      settingsPath = "/etc/naive/config.json";
    in {
      preStart = ''
        umask 0077
        mkdir -p /etc/naive
        ${utils.genJqSecretsReplacementSnippet settings settingsPath}
      '';
      description = "naiveproxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${getExe pkgs.naive} --config ${settingsPath}";
      };
    };

    sops.secrets."naive/client" = {
      owner = user;
      sopsFile = ./secrets.yaml;
    };
  };
}
