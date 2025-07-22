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
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-Gsuo+ripJSgKSYOM9/yl6Kt/6BFCA6BuTDvPdteinAI=";
      };
      globalConfig = ''
        dns cloudflare {env.CF_API_TOKEN}
      '';
      environmentFile = config.sops.templates.caddy.path;
    };

    sops.secrets.cf-api-token = {
      key = "tokens/cf_tls_token";
      owner = config.services.caddy.user;
      restartUnits = [ config.systemd.services.caddy.name ];
    };

    sops.templates.caddy = {
      content = "CF_API_TOKEN=${config.sops.placeholder.cf-api-token}";
      owner = config.services.caddy.user;
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/caddy" ];
    };
  };
}
