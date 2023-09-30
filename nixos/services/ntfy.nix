{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.ntfy;
in {
  options.services'.ntfy = {
    enable = mkEnableOption "ntfy-sh" // {default = cfg.port != null;};
    port = mkOption {
      type = with types; nullOr port;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [cfg.port];

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.snakepi.xyz";
        listen-http = ":${toString cfg.port}";
        behind-proxy = true;
      };
    };

    services.caddy.virtualHosts."ntfy.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
