{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.harmonia;
  port = 5222;
in {
  options.services'.harmonia.enable = mkEnableOption "harmonia";

  config = mkIf cfg.enable {
    users = {
      users.harmonia = {
        group = "harmonia";
        isSystemUser = true;
      };
      groups.harmonia = {};
    };

    networking.firewall.allowedTCPPorts = [port];

    services.harmonia = {
      enable = true;
      signKeyPath = config.sops.secrets.harmonia.path;
      settings = {
        bind = "[::]:${toString port}";
        workers = 5;
        max_connection_rate = 256;
        priority = 30;
      };
    };

    services.caddy.virtualHosts."cache.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        tls {
          import ${config.sops.secrets.cloudflare.path}
        }

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

    sops.secrets.harmonia = {
      owner = "harmonia";
      group = "harmonia";
      sopsFile = ./secrets.yaml;
    };
  };
}
