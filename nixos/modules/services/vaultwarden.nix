{ config, lib, ... }:
let
  cfg = config.services'.vaultwarden;
in
{
  options.services'.vaultwarden.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.snakepi.xyz";
        SIGNUPS_ALLOWED = false;

        ROCKET_PORT = 8222;

        PUSH_ENABLED = true;

        SMTP_HOST = "smtp.gmail.com";
        SMTP_FROM = "vault@snakepi.eu.org";
        SMTP_FROM_NAME = "Vaultwarden";
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 587;
        SMTP_USERNAME = "jstengyufei";
      };
      environmentFile = config.sops.secrets.vaultwarden.path;
    };

    services.caddy.virtualHosts.vault =
      let
        port = config.services.vaultwarden.config.ROCKET_PORT;
      in
      {
        hostName = "vault.snakepi.xyz";
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
      owner = "vaultwarden";
      sopsFile = ./secrets.yaml;
      restartUnits = [ "vaultwarden.service" ];
    };
  };
}
