{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.caddy;
in {
  options.services'.caddy.enable = mkEnableOption "Caddy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      adapter = "caddyfile";
      globalConfig = "order forward_proxy before reverse_proxy";
      acmeCA = null;
    };

    systemd.services.caddy.serviceConfig = {
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
    };

    age.secrets.caddy = {
      file = config.age.file + /services/caddy.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
