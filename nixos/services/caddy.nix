{ config, lib, ... }:
with lib;
let cfg = config.services'.caddy;
in {
  options.services'.caddy.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    services.caddy.enable = true;

    sops.secrets.cloudflare = {
      owner = config.services.caddy.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ "caddy.service" ];
    };
  };
}
