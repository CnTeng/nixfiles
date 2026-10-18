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
  options.services'.caddy.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
        hash = "sha256-xRJ5evsAJ2akg47j3Bt6YDXJOgX88B/rKNP50KSVyNY=";
      };
      globalConfig = ''
        admin off
        dns cloudflare {env.CF_API_TOKEN}
      '';
      enableReload = false;
      environmentFile = config.sops.templates."caddy/env".path;
      openFirewall = true;
    };

    sops.secrets.cf_api_token = {
      key = "tokens/cf_tls_token";
      owner = config.services.caddy.user;
      restartUnits = [ config.systemd.services.caddy.name ];
    };

    sops.templates."caddy/env" = {
      content = "CF_API_TOKEN=${config.sops.placeholder.cf_api_token}";
      owner = config.services.caddy.user;
    };

    preservation'.os.directories = [
      {
        directory = config.services.caddy.dataDir;
        inherit (config.services.caddy) user group;
      }
    ];
  };
}
