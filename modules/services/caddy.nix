{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.services.caddy;
in {
  options.custom.services.caddy.enable = mkEnableOption "caddy";

  config = mkIf cfg.enable {
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

    age.secrets.caddyFile = {
      file = ../../secrets/server/caddyFile.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
