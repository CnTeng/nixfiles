{
  inputs,
  config,
  lib,
  pkgs,
  utils,
  user,
  ...
}:
with lib; let
  cfg = config.services'.dae;

  configFile = pkgs.writeTextFile {
    name = "config.dae";
    text = ''
      global {
        wan_interface: auto

        log_level: info
        allow_insecure: false
        auto_config_kernel_parameter: true
      }

      node {
        'http://127.0.0.1:1080'
      }

      dns {
        upstream {
          googledns: 'tcp+udp://dns.google.com:53'
          alidns: 'udp://dns.alidns.com:53'
        }
        routing {
          request {
            fallback: alidns
          }
          response {
            upstream(googledns) -> accept
            !qname(geosite:cn) && ip(geoip:private) -> googledns
            fallback: accept
          }
        }
      }

      group {
        proxy {
          #filter: name(keyword: HK, keyword: SG)
          policy: min_moving_avg
        }
      }

      routing {
        pname(NetworkManager, naive) -> must_direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct

        dip(geoip:private) -> direct
        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct

        fallback: proxy
      }
    '';
  };
in {
  imports = [inputs.dae.nixosModules.dae];

  options.services'.dae.enable = mkEnableOption "dae";

  config = mkIf cfg.enable {
    environment.etc."dae/config.dae" = {
      mode = "0600";
      source = configFile;
    };

    services.dae = {
      enable = true;
      package = pkgs.dae;
      assets = with pkgs; [v2ray-geoip v2ray-domain-list-community];
      openFirewall = {
        enable = true;
        port = 12345;
      };
      configFile = "/etc/dae/config.dae";
      disableTxChecksumIpGeneric = false;
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
