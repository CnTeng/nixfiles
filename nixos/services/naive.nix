{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.naive;
in {
  options.services'.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable {
    services'.caddy.enable = true;

    boot = {
      kernelModules = ["tcp_bbr"];
      kernel.sysctl = {
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    };

    services.caddy = {
      globalConfig = "order forward_proxy before reverse_proxy";
      extraConfig = ''
        :443, ${config.networking.hostName}.snakepi.xyz {
        	tls yufei.teng@pm.me

          forward_proxy {
            import ${config.sops.secrets."naive/server".path}
            hide_ip
            hide_via
            probe_resistance
          }

          reverse_proxy https://nixos.org {
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
      restartUnits = ["caddy.service"];
    };
  };
}
