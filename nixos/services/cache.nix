{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.cache;
in {
  options.services'.cache.enable = mkEnableOption "harmonia";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [5222];

    services.harmonia = {
      enable = true;
      signKeyPath = config.age.secrets.cache.path;
      settings = {
        bind = "[::]:5222";
        workers = 5;
        max_connection_rate = 256;
        priority = 30;
      };
    };

    services.caddy.virtualHosts."cache.snakepi.xyz" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/cache.log
      '';
      extraConfig = ''
        import ${config.age.secrets.caddy.path}

        reverse_proxy 127.0.0.1:5222
      '';
    };

    age.secrets.cache = {
      file = config.age.file + /services/cache.age;
      owner = "harmonia";
      group = "harmonia";
      mode = "644";
    };
  };
}
