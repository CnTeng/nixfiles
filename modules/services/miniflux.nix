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

    services = {
      miniflux = {
        enable = true;
        config = {
          LISTEN_ADDR = "localhost:6222";
          BASE_URL = "https://rss.snakepi.xyz";
        };
        adminCredentialsFile = config.age.secrets.miniflux.path;
      };

      caddy.virtualHosts = {
        "rss.snakepi.xyz" = {
          logFormat = ''
            output file ${config.services.caddy.logDir}/rss.log
          '';
          extraConfig = ''
            import ${config.age.secrets.caddy.path}

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
          logFormat = ''
            output file ${config.services.caddy.logDir}/rsshub.log
          '';
          extraConfig = ''
            import ${config.age.secrets.caddy.path}

            bind

            encode gzip

            reverse_proxy 127.0.0.1:1200
          '';
        };
      };
    };

    age.secrets.miniflux = {
      file = ../../secrets/services/miniflux.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
