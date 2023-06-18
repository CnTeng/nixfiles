{ config, lib, ... }:
with lib;
let
  cfg = config.hardware'.kernel;
  inherit (cfg) modules;
in {
  options.hardware'.kernel = {
    modules = mapAttrs (_: doc: mkEnableOption (mkDoc doc)) {
      zswap = "zswap";
      bbr = "BBR module";
    };
  };

  config = mkMerge [
    (mkIf modules.zswap {
      boot = {
        initrd.availableKernelModules = [ "lz4" "z3fold" ];
        kernelParams = [
          "zswap.enabled=1"
          "zswap.max_pool_percent=25"
          "zswap.compressor=lz4"
          "zswap.zpool=z3fold"
        ];
      };
    })

    (mkIf modules.bbr {
      boot = {
        kernelModules = [ "tcp_bbr" ];
        kernel.sysctl = {
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "cake";
        };
      };
    })
  ];
}
