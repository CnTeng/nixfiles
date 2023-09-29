{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.authelia;
in {
  options.services'.authelia.enable = mkEnableOption "authelia";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [9091];

    services.authelia.instances.default = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets."authelia/jwt".path;
        storageEncryptionKeyFile = config.sops.secrets."authelia/encryption".path;
        oidcHmacSecretFile = config.sops.secrets."authelia/oidc/hmac".path;
        oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidc/issuer".path;
      };
      settings = {
        theme = "auto";
        session = {
          domain = "snakepi.xyz";
        };
        storage.local.path = "/var/lib/authelia-default/db.sqlite3";
        authentication_backend = {
          password_reset.disable = true;
          file.path = config.sops.secrets."authelia/users".path;
        };
        notifier.smtp = {
          host = "smtp.gmail.com";
          port = 587;
          username = "jstengyufei";
          sender = "Authelia <auth@snakepi.eu.org>";
          identifier = "snakepi.eu.org";
        };
        access_control.default_policy = "one_factor";
        identity_providers.oidc.clients = [
          {
            id = "miniflux";
            secret = "$pbkdf2-sha512$310000$wqRD8gk.yEkCKJfShbf05g$5igJi70xWSxkxiP3nQIGqVINeWF6tjfIO0Y.hB4h3yZ49xodHZTvCiQowhfNQzB4sghV/1gMUP42V.xVLb0z9g";
            redirect_uris = ["https://rss.snakepi.xyz/oauth2/oidc/callback"];
            authorization_policy = "two_factor";
            scopes = ["openid" "profile" "email"];
          }
        ];
      };
      environmentVariables = {
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets."authelia/smtp".path;
      };
    };

    sops.secrets = {
      "authelia/jwt" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
      "authelia/encryption" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
      "authelia/users" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
      "authelia/smtp" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
        key = "smtp";
      };
      "authelia/oidc/hmac" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
      "authelia/oidc/issuer" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
    };

    services.caddy.virtualHosts."auth.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        reverse_proxy 127.0.0.1:9091
      '';
    };
  };
}
