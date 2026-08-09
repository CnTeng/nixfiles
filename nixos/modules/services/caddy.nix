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
        hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
      };
      globalConfig = ''
        admin off
        dns cloudflare {env.CF_API_TOKEN}
      '';
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
