{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.vaultwarden;
in {
  options.services'.vaultwarden = {
    enable = mkEnableOption "Vaultwarden" // {default = cfg.port != null;};
    port = mkOption {
      type = with types; nullOr port;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [cfg.port];

    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.snakepi.xyz";
        SIGNUPS_ALLOWED = false;

        ROCKET_PORT = cfg.port;

        PUSH_ENABLED = true;

        DISABLE_ADMIN_TOKEN = true;

        SMTP_HOST = "smtp.gmail.com";
        SMTP_FROM = "vault@snakepi.eu.org";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 587;
        SMTP_USERNAME = "jstengyufei";
      };
      environmentFile = config.sops.secrets.vaultwarden.path;
    };

    services.caddy.virtualHosts."vault.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        encode gzip

        header {
          Strict-Transport-Security "max-age=31536000;"
          X-XSS-Protection "1; mode=block"
          X-Frame-Options "SAMEORIGIN"
          X-Robots-Tag "none"
          -Server
        }

        forward_auth /admin localhost:${toString config.services'.authelia.port} {
          uri /api/verify?rd=https://auth.snakepi.xyz/
          copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
        }

        reverse_proxy localhost:${toString cfg.port} {
          header_up X-Real-IP {remote_host}
        }
      '';
    };

    sops.secrets.vaultwarden = {
      path = "/var/lib/vaultwarden.env";
      owner = "vaultwarden";
      sopsFile = ./secrets.yaml;
      restartUnits = ["vaultwarden.service"];
    };
  };
}
