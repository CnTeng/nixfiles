{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.miniflux;
in {
  options.services'.miniflux.enable = mkEnableOption "MiniFlux";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [1200 6222];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.rsshub = {
        image = "diygod/rsshub";
        ports = ["1200:1200"];
        environment = {
          HOTLINK_TEMPLATE = "https://i3.wp.com/\${host}\${pathname}";
        };
      };
    };

    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:6222";
        BASE_URL = "https://rss.snakepi.xyz";
      };
      adminCredentialsFile = config.sops.secrets.miniflux.path;
    };

    services.caddy.virtualHosts = {
      "rss.snakepi.xyz" = {
        logFormat = "output stdout";
        extraConfig = ''
          import ${config.sops.secrets.cloudflare.path}

          bind

          encode gzip

          header / {
            X-XSS-Protection "1; mode=block"
            X-Frame-Options "SAMEORIGIN"
          }

          reverse_proxy 127.0.0.1:6222
        '';
      };

      "rsshub.snakepi.xyz" = {
        logFormat = "output stdout";
        extraConfig = ''
          import ${config.sops.secrets.cloudflare.path}

          bind

          encode gzip

          reverse_proxy 127.0.0.1:1200
        '';
      };
    };

    sops.secrets.miniflux = {
      owner = user;
      sopsFile = ./secrets.yaml;
    };
  };
}
