{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.services.naive;
in {
  options.custom.services.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable (mkMerge [
    (mkIf (!config.custom.services.caddy.enable) {
      services.caddy = {
        enable = true;
        package = pkgs.caddy-with-plugins;
        logDir = "/var/log/caddy";
        adapter = "caddyfile";
        configFile = config.age.secrets.caddyFile.path;
      };

      systemd.services.caddy.serviceConfig = {
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
      };

      services.caddy.extraConfig = ''
        :443, ${config.networking.hostName}.snakepi.xyz {
        	log {
        		output file ${config.services.caddy.logDir}/naive.log
        	}

        	tls istengyf@outlook.com

          import ${config.age.secrets.caddy.path}
        }
      '';

      age.secrets.caddy = {
        file = ../../secrets/services/naive.age;
        owner = "${user}";
        group = "users";
        mode = "644";
      };

      age.secrets.caddyFile = {
        file = ../../secrets/services/naiveFile.age;
        owner = "${user}";
        group = "users";
        mode = "644";
      };
    })
  ]);
}
