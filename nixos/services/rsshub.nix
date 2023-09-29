{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.rsshub;
in {
  options.services'.rsshub.enable = mkEnableOption "Rsshub";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [1200];

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

    services.caddy.virtualHosts."rsshub.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        encode gzip

        reverse_proxy 127.0.0.1:1200
      '';
    };
  };
}
