{
  config,
  lib,
  pkgs,
  ...
}:
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

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = "sha256-JoujVXRXjKUam1Ej3/zKVvF0nX97dUizmISjy3M3Kr8=";
      };
    };

    sops.secrets.cf-cdntls-token = {
      key = "tokens/cf_cdntls";
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
