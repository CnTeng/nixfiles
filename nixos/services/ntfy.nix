{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.ntfy;
in {
  options.services'.ntfy.enable = mkEnableOption "ntfy-sh";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [7222];

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.snakepi.xyz";
        listen-http = ":7222";
        behind-proxy = true;
      };
    };

    services.caddy.virtualHosts."ntfy.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        reverse_proxy 127.0.0.1:7222
      '';
    };
  };
}
