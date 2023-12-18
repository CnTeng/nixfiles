{ config, lib, ... }:
with lib;
let cfg = config.hardware'.nvidia;
in {
  options.hardware'.nvidia.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      modesetting.enable = true;

      prime = {
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
