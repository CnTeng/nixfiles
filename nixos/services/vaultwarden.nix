{ config, lib, ... }:
with lib;
let
  cfg = config.services'.vaultwarden;
  port = 8222;
  smtpPort = 587;
in {
  options.services'.vaultwarden.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port smtpPort ];

    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.snakepi.xyz";
        SIGNUPS_ALLOWED = false;

        ROCKET_PORT = port;

        PUSH_ENABLED = true;

        SMTP_HOST = "smtp.gmail.com";
        SMTP_FROM = "vault@snakepi.eu.org";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = smtpPort;
        SMTP_USERNAME = "jstengyufei";
      };
      environmentFile = config.sops.secrets.vaultwarden.path;
    };

    services.caddy.virtualHosts."vault.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

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
      path = "/var/lib/vaultwarden.env";
      owner = "vaultwarden";
      sopsFile = ./secrets.yaml;
      restartUnits = [ "vaultwarden.service" ];
    };
  };
}
