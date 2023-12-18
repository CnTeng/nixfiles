{ config, lib, ... }:
with lib;
let cfg = config.services'.naive;
in {
  options.services'.naive.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services'.caddy.enable = true;

    services.caddy = {
      globalConfig = "order forward_proxy before reverse_proxy";
      extraConfig = ''
        :443, naive.snakepi.xyz {
        	tls yufei.teng@pm.me

          forward_proxy {
            import ${config.sops.secrets."naive/server".path}
            hide_ip
            hide_via
            probe_resistance
          }

          reverse_proxy https://github.com {
            header_up Host {upstream_hostport}
          }
        }
      '';
    };

    systemd.services.caddy.serviceConfig = {
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
    };

    sops.secrets."naive/server" = {
      owner = config.services.caddy.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ "caddy.service" ];
    };
  };
}
