{ config, lib, ... }:
with lib;
let cfg = config.services'.naive;
in {
  options.services'.naive.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    services.sing-box = {
      enable = true;
      settings.inbounds = [{
        type = "naive";
        listen = "::";
        listen_port = 443;
        users = [{
          username._secret = config.sops.secrets."naive-server/username".path;
          password._secret = config.sops.secrets."naive-server/password".path;
        }];
        tls = {
          enabled = true;
          server_name = "naive.snakepi.xyz";
          acme = {
            domain = "naive.snakepi.xyz";
            email = "isyufei.teng@gmail.com";
            dns01_challenge = {
              provider = "cloudflare";
              api_token._secret = config.sops.secrets."CLOUDFLARE_API_KEY".path;
            };
          };
        };
      }];

    };

    sops.secrets = {
      "CLOUDFLARE_API_KEY" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };

      "naive-server/username" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };

      "naive-server/password" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };
    };
  };
}
