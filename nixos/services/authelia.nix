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
      };
      settings = {
        theme = "auto";
        session = {
          domain = "auth.snakepi.xyz";
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

        access_control = {
          default_policy = "two_factor";
        };
      };
      environmentVariables = {
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets.smtp.path;
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
      "smtp" = {
        owner = config.services.authelia.instances.default.user;
        sopsFile = ./secrets.yaml;
      };
    };

    services.caddy.virtualHosts."auth.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        import ${config.sops.secrets.cloudflare.path}

        reverse_proxy 127.0.0.1:9091
      '';
    };
  };
}
