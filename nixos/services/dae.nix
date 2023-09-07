{
  config,
  lib,
  pkgs,
  utils,
  user,
  ...
}:
with lib; let
  cfg = config.services'.dae;
in {
  options.services'.dae.enable = mkEnableOption "dae";

  config = mkIf cfg.enable {
    services.dae = {
      enable = true;
      config = ''
        global {
          log_level: debug

          wan_interface: auto
          auto_config_kernel_parameter: true
        }

        node {
          naive: 'http://127.0.0.1:1080'
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
          pname(NetworkManager, naive) -> must_direct

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

    systemd.services.naiveproxy = let
      settings = {
        listen = "http://127.0.0.1:1080";
        proxy._secret = config.age.secrets.dae.path;
      };
      settingsPath = "/etc/naive/config.json";
    in {
      preStart = ''
        umask 0077
        mkdir -p /etc/naive
        ${utils.genJqSecretsReplacementSnippet settings settingsPath}
      '';
      description = "naiveproxy Daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${getExe pkgs.naive} --config ${settingsPath}";
      };
    };

    age.secrets.dae = {
      file = config.age.file + /services/dae.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
