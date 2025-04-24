{ config, lib, ... }:
let
  cfg = config.services'.authelia;
in
{
  options.services'.authelia.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.authelia.instances.default = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
        storageEncryptionKeyFile = config.sops.secrets."authelia/encryption_key".path;
        oidcHmacSecretFile = config.sops.secrets."authelia/hmac_secret".path;
        oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/issuer_private_key".path;
      };
      settings = {
        theme = "auto";
        default_2fa_method = "webauthn";
        server.address = "unix:///run/authelia-default/authelia.sock?umask=0111";

        authentication_backend = {
          password_reset.disable = true;
          ldap = {
            address = "ldap://localhost:3890";
            implementation = "custom";
            timeout = "5s";
            start_tls = false;
            base_dn = "dc=snakepi,dc=xyz";
            additional_users_dn = "ou=people";
            users_filter = "(&({username_attribute}={input})(objectClass=person))";
            additional_groups_dn = "ou=groups";
            groups_filter = "(member={dn})";
            user = "uid=authelia,ou=people,dc=snakepi,dc=xyz";
            attributes = {
              username = "uid";
              display_name = "displayName";
              mail = "mail";
              group_name = "cn";
            };
          };
        };

        access_control.default_policy = "one_factor";

        session.cookies = [
          {
            domain = "snakepi.xyz";
            authelia_url = "https://auth.snakepi.xyz";
          }
        ];

        storage.local.path = "/var/lib/authelia-default/db.sqlite3";

        notifier.smtp = {
          address = "submission://smtp.gmail.com:587";
          username = "istengyf";
          sender = "Authelia <noreply@snakepi.xyz>";
          identifier = "snakepi.xyz";
        };
      };

      environmentVariables = {
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets."authelia/smtp_password".path;
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          config.sops.secrets."authelia/ldap_password".path;
      };
    };

    systemd.services.authelia-default.serviceConfig.RuntimeDirectory = "authelia-default";

    services.caddy.virtualHosts.auth = {
      hostName = "auth.snakepi.xyz";
      extraConfig = ''
        reverse_proxy "unix//run/authelia-default/authelia.sock"
      '';
    };

    sops.secrets = {
      "authelia/jwt_secret" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };

      "authelia/encryption_key" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };

      "authelia/hmac_secret" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };

      "authelia/issuer_private_key" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };

      "authelia/smtp_password" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };

      "authelia/ldap_password" = {
        owner = "authelia-default";
        sopsFile = ./secrets.yaml;
      };
    };
  };
}
