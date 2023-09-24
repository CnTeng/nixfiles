{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.hydra;
in {
  options.services'.hydra.enable = mkEnableOption "Hydra";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [9222];

    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.snakepi.xyz";
      listenHost = "localhost";
      port = 9222;
      notificationSender = "hydra@outlook.com";
      useSubstitutes = true;
    };

    boot.binfmt.emulatedSystems = ["x86_64-linux"];

    nix.buildMachines = [
      {
        hostName = "localhost";
        systems = ["x86_64-linux" "aarch64-linux"];
        maxJobs = 3;
      }
    ];

    services.caddy.virtualHosts."hydra.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        import ${config.sops.secrets.cloudflare.path}

        bind

        encode gzip

        reverse_proxy 127.0.0.1:9222
      '';
    };
  };
}
