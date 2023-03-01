{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.hardware.gpu.nvidia;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.custom.hardware.gpu.nvidia = {
    enable = mkEnableOption "Nvidia GPU support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ nvidia-offload ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      powerManagement = {
        # enable = true;
        finegrained = true;
      };

      modesetting.enable = true;

      prime = {
        intelBusId = "PCI:0:2:0";

        nvidiaBusId = "PCI:1:0:0";

        offload.enable = true;
      };

      nvidiaPersistenced = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
