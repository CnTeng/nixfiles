{ config, lib, ... }:
with lib;
let cfg = config.hardware'.optimise;
in {
  options.hardware'.optimise.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    zramSwap.enable = true;

    services.fstrim.enable = true;
  };
}
