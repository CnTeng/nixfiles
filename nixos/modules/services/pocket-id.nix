{ config, lib, ... }:
let
  cfg = config.services'.pocket-id;

  hostName = "id.snakepi.xyz";
  socket = "@pocket.sock";
in
{
  options.services'.pocket-id.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.pocket-id = {
      enable = true;
      settings = {
        APP_URL = "https://${hostName}";
        ENCRYPTION_KEY_FILE = config.sops.secrets."pocket-id/encryption_key".path;
        TRUST_PROXY = true;
        PUID = config.users.users.pocket-id.uid;
        PGID = config.users.groups.pocket-id.gid;
        UNIX_SOCKET = socket;
        UI_CONFIG_DISABLED = true;

        EMAILS_VERIFIED = true;
        SMTP_HOST = "smtp.gmail.com";
        SMTP_PORT = 587;
        SMTP_FROM = "noreply@snakepi.xyz";
        SMTP_USER = "istengyf";
        SMTP_PASSWORD_FILE = config.sops.secrets."pocket-id/smtp_password".path;
        SMTP_TLS = "starttls";
        EMAIL_LOGIN_NOTIFICATION_ENABLED = true;
        EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = true;
        EMAIL_API_KEY_EXPIRATION_ENABLED = true;
      };
    };

    services.caddy.virtualHosts.id = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    sops.secrets = {
      "pocket-id/encryption_key" = {
        owner = config.services.pocket-id.user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.pocket-id.name ];
      };

      "pocket-id/smtp_password" = {
        key = "smtp/password";
        owner = config.services.pocket-id.user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.pocket-id.name ];
      };
    };

    preservation'.os.directories = [
      {
        directory = config.services.pocket-id.dataDir;
        inherit (config.services.pocket-id) user group;
      }
    ];
  };
}
