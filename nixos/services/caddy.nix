{ config, lib, ... }:
with lib;
let cfg = config.services'.caddy;
in {
  options.services'.caddy.enable = mkEnableOption "Caddy";

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "cake";
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_notsent_lowat" = 16384;
    };

    services.caddy.enable = true;

    sops.secrets.cloudflare = {
      owner = config.services.caddy.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ "caddy.service" ];
    };
  };
}
