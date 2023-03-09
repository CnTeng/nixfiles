{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.services.caddy;
in {
  options.custom.services.caddy.enable = mkEnableOption "Caddy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy-with-plugins;
      configFile = config.age.secrets.caddyFile.path;
      adapter = "caddyfile";
      globalConfig = ''
        order forward_proxy before reverse_proxy

        log {
        	level ERROR
        }
      '';
    };

    systemd.services.caddy.serviceConfig = {
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
    };

    age.secrets.caddyFile = {
      file = ../../secrets/services/caddyFile.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };

    age.secrets.caddy = {
      file = ../../secrets/services/caddy.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
