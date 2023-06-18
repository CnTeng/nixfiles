{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services'.hydra;
in {
  options.services'.hydra.enable = mkEnableOption "Hydra";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 9222 ];

    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.snakepi.xyz";
      listenHost = "localhost";
      port = 9222;
      notificationSender = "hydra@outlook.com";
      useSubstitutes = true;
    };

    services.caddy.virtualHosts."hydra.snakepi.xyz" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/hydra.log
      '';
      extraConfig = ''
        import ${config.age.secrets.caddy.path}

        bind

        encode gzip

        reverse_proxy 127.0.0.1:9222
      '';
    };
  };
}
