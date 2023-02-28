{ config, lib, ... }:

with lib;

let cfg = config.custom.hardware.cpu;
in {
  options.custom.hardware.cpu = {
    intel.enable = mkEnableOption "Intel cpu support";
    cpuFreqGovernor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ondemand";
      description = lib.mdDoc ''
        One of "ondemand", "powersave", "performance"
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.intel.enable {
      hardware = {
        enableRedistributableFirmware = mkDefault true;
        cpu.intel.updateMicrocode =
          mkDefault config.hardware.enableRedistributableFirmware;
      };
    })
    { powerManagement.cpuFreqGovernor = "${cfg.cpuFreqGovernor}"; }
  ];
}
