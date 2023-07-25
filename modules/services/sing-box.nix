{
  config,
  lib,
  utils,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.services'.sing-box;
in {
  options.services'.sing-box.enable = mkEnableOption "sing-box";

  config = mkIf cfg.enable {
    systemd.services.naiveproxy = let
      settings = {
        listen = "http://127.0.0.1:1080";
        proxy._secret = config.age.secrets.sing-box.path;
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

    age.secrets.sing-box = {
      file = ../../secrets/services/sing-box.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };

    services.sing-box = {
      enable = true;
      settings = {
        log.level = "debug";
        dns = {
          servers = [
            {
              tag = "google";
              address = "tls://dns.google";
              address_resolver = "local";
              strategy = "prefer_ipv4";
            }
            {
              tag = "local";
              address = "local";
              strategy = "prefer_ipv4";
            }
          ];
          rules = [
            {
              geosite = ["cn"];
              server = "local";
            }
          ];
          final = "google";
        };
        inbounds = [
          {
            type = "mixed";
            tag = "mixed-in";
            listen = "127.0.0.1";
            listen_port = 10808;
            sniff = true;
            sniff_override_destination = true;
          }
        ];
        outbounds = [
          {
            type = "http";
            tag = "naive-out";
            server = "127.0.0.1";
            server_port = 1080;
          }
          {
            type = "direct";
            tag = "direct-out";
          }
        ];
        route = {
          rules = [
            {
              geosite = ["cn"];
              geoip = ["cn"];
              outbound = "direct-out";
            }
          ];
          final = "naive-out";
        };
      };
    };
  };
}
