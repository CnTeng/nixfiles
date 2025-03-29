{ config, lib, ... }:
let
  cfg = config.services'.miniflux;
in
{
  options.services'.miniflux.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "/run/miniflux/miniflux.sock";
        BASE_URL = "https://rss.snakepi.xyz";
        WEBAUTHN = "1";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_CLIENT_SECRET_FILE = config.sops.secrets."miniflux/oauth2_client_secret".path;
        OAUTH2_REDIRECT_URL = "https://rss.snakepi.xyz/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.snakepi.xyz";
        OAUTH2_USER_CREATION = "1";
      };
      adminCredentialsFile = config.sops.secrets."miniflux/admin_credentials".path;
    };

    systemd.services.miniflux.serviceConfig.RuntimeDirectoryMode = lib.mkForce "0755";

    services.authelia.instances.default = {
      settings.identity_providers.oidc.clients = [
        {
          client_id = "miniflux";
          client_secret = "$pbkdf2-sha512$310000$0F8wxRB4Tv03RSnpPEAnHA$fJxCTbGhUSxG894JORm4xwL2SgLe0slP9GX9CBGhM/.DyROSUJHj0.xGUuBGVU4Xq0Dv8n65ft/8oXQ4kzrtww";
          redirect_uris = [ "https://rss.snakepi.xyz/oauth2/oidc/callback" ];
          authorization_policy = "two_factor";
          scopes = [
            "openid"
            "profile"
            "email"
          ];
        }
      ];
    };

    services.caddy.virtualHosts.rss = {
      hostName = "rss.snakepi.xyz";
      extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }

        reverse_proxy "unix/${config.services.miniflux.config.LISTEN_ADDR}"
      '';
    };

    users.users.miniflux = {
      group = "miniflux";
      isSystemUser = true;
    };
    users.groups.miniflux = { };

    sops.secrets = {
      "miniflux/oauth2_client_secret" = {
        owner = "miniflux";
        sopsFile = ./secrets.yaml;
      };
      "miniflux/admin_credentials" = {
        owner = "miniflux";
        sopsFile = ./secrets.yaml;
      };
    };
  };
}
