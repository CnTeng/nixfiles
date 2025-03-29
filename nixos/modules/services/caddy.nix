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
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de" ];
        hash = "sha256-YYpsf8HMONR1teMiSymo2y+HrKoxuJMKIea5/NEykGc=";
      };
      environmentFile = config.sops.templates.caddy.path;
    };

    sops.secrets.cf-api-token = {
      key = "tokens/cf_api";
      owner = config.services.caddy.user;
      restartUnits = [ "caddy.service" ];
    };

    sops.templates.caddy = {
      content = "CF_API_TOKEN=${config.sops.placeholder.cf-api-token}";
      owner = config.services.caddy.user;
    };
  };
}
