{
  config,
  data,
  lib,
  ...
}:
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
        uploadBucketUrl = "https://${data.r2.endpoint}";
        uploadBucketName = "outline";
      };
    };

    systemd.services.outline = {
      environment = {
        SECRET_KEY_FILE = config.sops.secrets."outline/secret_key".path;
        UTILS_SECRET_FILE = config.sops.secrets."outline/utils_secret".path;

        AWS_ACCESS_KEY_ID_FILE = config.sops.secrets."outline/r2-access-key".path;
        AWS_SECRET_ACCESS_KEY_FILE = config.sops.secrets."outline/r2-secret-key".path;
        AWS_S3_UPLOAD_METHOD = "put";

        DATABASE_URL = "postgres://localhost/outline?host=/run/postgresql";
        PGSSLMODE = "disable";

        OIDC_ISSUER_URL = "https://id.snakepi.xyz";

        SMTP_SERVICE = "Gmail";
        SMTP_FROM_EMAIL = "Outline <noreply@snakepi.xyz>";
      };

      preStart = lib.mkForce "";
      script = lib.mkForce "";

      serviceConfig = {
        ExecStart = lib.getExe' config.services.outline.package "outline-server";
        EnvironmentFile = config.sops.secrets."outline/env".path;
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
      };

      "outline/utils_secret" = {
        owner = config.services.outline.user;
        sopsFile = ./secrets.yaml;
      };

      "outline/env" = {
        owner = config.services.outline.user;
        sopsFile = ./secrets.yaml;
      };

      "outline/r2-access-key" = {
        key = "r2/outline/access_key";
        owner = config.services.outline.user;
      };

      "outline/r2-secret-key" = {
        key = "r2/outline/secret_key";
        owner = config.services.outline.user;
      };
    };
  };
}
