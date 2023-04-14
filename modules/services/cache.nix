{ config, lib, pkgs, user, inputs, ... }:
with lib;
let cfg = config.services'.cache;
in {
  imports = [ inputs.harmonia.nixosModules.harmonia ];
  options.services'.cache.enable = mkEnableOption "harmonia";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 5222 ];

    services.harmonia = {
      enable = true;
      settings = {
        bind = "[::]:5222";
        workers = 5;
        max_connection_rate = 256;
        priority = 30;
        sign_key_path = config.age.secrets.cache.path;
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
      file = ../../secrets/services/cache.age;
      owner = "harmonia";
      group = "harmonia";
      mode = "644";
    };
  };
}
