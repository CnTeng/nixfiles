{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware'.gpu.intel;
in {
  options.hardware'.gpu.intel.enable =
    mkEnableOption "Intel GPU support"
    // {
      default = config.hardware'.cpu.intel.enable;
    };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = ["i915"];

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        intel-media-driver
        libvdpau-va-gl
        vaapiVdpau
      ];
    };

    environment = {
      systemPackages = with pkgs; [intel-gpu-tools libva-utils pciutils];
      variables.VDPAU_DRIVER = "va_gl";
    };
  };
}
