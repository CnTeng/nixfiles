{ config, lib, user, ... }:

with lib;

let cfg = config.custom.services.naive;
in {
  options.custom.services.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable (mkMerge [
    { networking.firewall.allowedTCPPorts = [ 5222 ]; }
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

      age.secrets.caddyFile = {
        file = ../../secrets/services/naiveFile.age;
        owner = "${user}";
        group = "users";
        mode = "644";
      };
    })
  ]);
}
