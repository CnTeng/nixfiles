{ config, lib, ... }:
let
  cfg = config.services'.outline;

  hostName = "wiki.snakepi.xyz";
  port = 3222;
in
{
  options.services'.outline.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.outline = {
      enable = true;
      publicUrl = "https://${hostName}";
      inherit port;

      storage = {
        storageType = "s3";
        accessKey = "unset";
        secretKeyFile = "/unset";
        region = "auto";
        uploadBucketUrl = "https://${config.core'.serviceInfo.r2.endpoint}";
        uploadBucketName = "outline";
      };
    };

    systemd.services.outline = {
      environment = {
        SERVICES = "collaboration,websockets,worker,web,cron";

        SECRET_KEY_FILE = config.sops.secrets."outline/secret_key".path;
        UTILS_SECRET_FILE = config.sops.secrets."outline/utils_secret".path;

        AWS_ACCESS_KEY_ID_FILE = config.sops.secrets."outline/r2_access_key".path;
        AWS_SECRET_ACCESS_KEY_FILE = config.sops.secrets."outline/r2_secret_key".path;
        AWS_S3_UPLOAD_METHOD = "put";

        DATABASE_URL = "postgres://localhost/outline?host=/run/postgresql";
        PGSSLMODE = "disable";

        OIDC_ISSUER_URL = "https://id.snakepi.xyz";
        OIDC_CLIENT_ID_FILE = config.sops.secrets."outline/oidc_client_id".path;
        OIDC_CLIENT_SECRET_FILE = config.sops.secrets."outline/oidc_client_secret".path;

        SMTP_HOST = "smtp.gmail.com";
        SMTP_PORT = "587";
        SMTP_USERNAME = "istengyf";
        SMTP_PASSWORD_FILE = config.sops.secrets."outline/smtp_password".path;
        SMTP_SECURE = "false";
        SMTP_FROM_EMAIL = "Outline <noreply@snakepi.xyz>";
      };

      preStart = lib.mkForce "";
      script = lib.mkForce "";

      serviceConfig = {
        ExecStart = lib.getExe' config.services.outline.package "outline-server";
        UnsetEnvironment = [ "AWS_ACCESS_KEY_ID" ];
      };
    };

    services.caddy.virtualHosts.outline = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };

    sops.secrets = {
      "outline/secret_key" = {
        owner = config.services.outline.user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/utils_secret" = {
        owner = config.services.outline.user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/oidc_client_id" = {
        key = "oidc/outline/client_id";
        owner = config.services.outline.user;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/oidc_client_secret" = {
        key = "oidc/outline/client_secret";
        owner = config.services.outline.user;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/smtp_password" = {
        key = "smtp/password";
        owner = config.services.outline.user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/r2_access_key" = {
        key = "r2/outline/access_key";
        owner = config.services.outline.user;
        restartUnits = [ config.systemd.services.outline.name ];
      };

      "outline/r2_secret_key" = {
        key = "r2/outline/secret_key";
        owner = config.services.outline.user;
        restartUnits = [ config.systemd.services.outline.name ];
      };
    };
  };
}
