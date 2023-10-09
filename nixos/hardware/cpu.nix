{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware'.cpu;
in {
  options.hardware'.cpu.enable = mkEnableOption "Intel CPU support";

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = ["i915"];

    hardware.enableAllFirmware = true;

    hardware.cpu.intel.updateMicrocode = true;
  };
}
