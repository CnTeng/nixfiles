{ config, lib, ... }:
let
  cfg = config.services'.vaultwarden;

  hostName = "vault.snakepi.xyz";
  port = 8222;
  user = "vaultwarden";
in
{
  options.services'.vaultwarden.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://${hostName}";
        SIGNUPS_ALLOWED = false;

        ROCKET_PORT = port;

        PUSH_ENABLED = true;

        SMTP_HOST = "smtp.gmail.com";
        SMTP_FROM = "noreply@snakepi.xyz";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 587;

        EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "fido2-vault-credentials,ssh-key-vault-item,ssh-agent";
      };
      environmentFile = config.sops.secrets.vaultwarden.path;
    };

    services.caddy.virtualHosts.vault = {
      inherit hostName;
      extraConfig = ''
        header / {
          Strict-Transport-Security "max-age=31536000;"
          X-XSS-Protection "0"
          X-Frame-Options "SAMEORIGIN"
          X-Robots-Tag "noindex, nofollow"
          X-Content-Type-Options "nosniff"
          -Server
          -X-Powered-By
          -Last-Modified
        }

        reverse_proxy localhost:${toString port} {
          header_up X-Real-IP {remote_host}
        }
      '';
    };

    sops.secrets.vaultwarden = {
      owner = user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.vaultwarden.name ];
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/vaultwarden" ];
    };
  };
}
