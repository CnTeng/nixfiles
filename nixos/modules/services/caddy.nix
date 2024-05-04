{ config, lib, ... }:
let
  cfg = config.services'.caddy;
in
{
  options.services'.caddy.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy.enable = true;

    sops.secrets.cf-cdntls-token = {
      key = "cf-api-token";
      owner = config.services.caddy.user;
      restartUnits = [ "caddy.service" ];
    };

    sops.templates.cf-tls = {
      content = ''
        tls {
          dns cloudflare ${config.sops.placeholder.cf-cdntls-token}
        }
      '';
      owner = config.services.caddy.user;
    };
  };
}
