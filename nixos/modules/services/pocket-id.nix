{ config, lib, ... }:
let
  cfg = config.services'.pocket-id;

  hostName = "id.snakepi.xyz";
  port = 1411;
in
{
  options.services'.pocket-id.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.pocket-id = {
      enable = true;
      environmentFile = config.sops.secrets.pocket-id.path;
      settings = {
        APP_URL = "https://${hostName}";
        TRUST_PROXY = true;
        PUID = config.users.users.pocket-id.uid;
        PGID = config.users.groups.pocket-id.gid;
        UI_CONFIG_DISABLED = true;

        EMAILS_VERIFIED = true;
        SMTP_HOST = "smtp.gmail.com";
        SMTP_PORT = 587;
        SMTP_FROM = "noreply@snakepi.xyz";
        SMTP_TLS = "starttls";
        EMAIL_LOGIN_NOTIFICATION_ENABLED = true;
        EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = true;
        EMAIL_API_KEY_EXPIRATION_ENABLED = true;
      };
    };

    services.caddy.virtualHosts.id = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

    sops.secrets.pocket-id = {
      owner = config.services.pocket-id.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.pocket-id.name ];
    };
  };
}
