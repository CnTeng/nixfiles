{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.miniflux;
in {
  options.services'.miniflux = {
    enable = mkEnableOption "MiniFlux" // {default = cfg.port != null;};
    port = mkOption {
      type = with types; nullOr port;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [cfg.port];

    services.miniflux = {
      enable = true;
      config = {
        CREATE_ADMIN = mkForce "";
        LISTEN_ADDR = "localhost:${toString cfg.port}";
        BASE_URL = "https://rss.snakepi.xyz";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_REDIRECT_URL = "https://rss.snakepi.xyz/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.snakepi.xyz";
        OAUTH2_USER_CREATION = "1";
      };
      adminCredentialsFile = config.sops.secrets.miniflux.path;
    };

    services.caddy.virtualHosts."rss.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        header / {
          X-XSS-Protection "1; mode=block"
          X-Frame-Options "SAMEORIGIN"
        }

        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };

    sops.secrets.miniflux = {
      owner = user;
      sopsFile = ./secrets.yaml;
    };
  };
}
