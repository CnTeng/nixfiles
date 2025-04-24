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
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20250420134112-006ebb07b349" ];
        hash = "sha256-aCGKKorzRVJzerqy/MjOqaBfV90ULuRiEPL00wYCrhM=";
      };
      globalConfig = ''
        dns cloudflare {env.CF_API_TOKEN}
      '';
      environmentFile = config.sops.templates.caddy.path;
    };

    sops.secrets.cf-api-token = {
      key = "tokens/cf_tls_token";
      owner = config.services.caddy.user;
      restartUnits = [ "caddy.service" ];
    };

    sops.templates.caddy = {
      content = "CF_API_TOKEN=${config.sops.placeholder.cf-api-token}";
      owner = config.services.caddy.user;
    };
  };
}
