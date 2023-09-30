{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.rsshub;
in {
  options.services'.rsshub = {
    enable = mkEnableOption "Rsshub" // {default = cfg.port != null;};
    port = mkOption {
      type = with types; nullOr port;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [cfg.port];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.rsshub = {
        image = "diygod/rsshub";
        ports = ["${toString cfg.port}:${toString cfg.port}"];
        environment = {
          HOTLINK_TEMPLATE = "https://i3.wp.com/\${host}\${pathname}";
        };
      };
    };

    services.caddy.virtualHosts."rsshub.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        encode gzip

        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
