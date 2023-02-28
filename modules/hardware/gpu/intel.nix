{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.hardware.gpu.intel;
in {
  options.custom.hardware.gpu.intel = {
    enable = mkEnableOption "Intel gpu support" // {
      default = config.custom.hardware.cpu.intel.enable;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "i915" ];

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-ocl
        vaapiIntel
        libvdpau-va-gl
      ];
    };

    environment = {
      systemPackages = with pkgs; [ intel-gpu-tools libva-utils ];
      variables = { VDPAU_DRIVER = "va_gl"; };
    };
  };
}
