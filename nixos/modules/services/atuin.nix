{ config, lib, ... }:
let
  cfg = config.services'.atuin;
in
{
  options.services'.atuin.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.atuin = {
      enable = true;
      openRegistration = true;
    };

    services.caddy.virtualHosts.atuin = {
      hostName = "atuin.snakepi.xyz";
      extraConfig = ''
        tls {
          dns cloudflare {$CF_API_TOKEN}
        }

        reverse_proxy 127.0.0.1:${toString config.services.atuin.port}
      '';
    };
  };
}
