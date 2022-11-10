{ pkgs, config, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy-with-plugins;
    logDir = "/var/log/caddy";
    adapter = "caddyfile";
    configFile = config.age.secrets.Caddyfile.path;
  };

  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities = "cap_net_bind_service";
    CapabilityBoundingSet = "cap_net_bind_service";
  };
}
