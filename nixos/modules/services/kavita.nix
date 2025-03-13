{ config, lib, ... }:
let
  cfg = config.services'.kavita;
in
{
  options.services'.kavita.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.kavita = {
      enable = true;
      tokenKeyFile = config.sops.secrets.kavita-token.path;
      settings = {
      };
    };

    services.caddy.virtualHosts.kavita = {
      hostName = "book.snakepi.xyz";
      extraConfig = ''
        tls {
          dns cloudflare {$CF_API_TOKEN}
        }

        encode gzip
        reverse_proxy 127.0.0.1:${toString config.services.kavita.settings.Port}
      '';
    };

    sops.secrets.kavita-token = {
      key = "kavita/token";
      owner = config.services.kavita.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ "kavita.service" ];
    };
  };
}
