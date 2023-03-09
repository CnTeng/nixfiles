{ config, lib, ... }:

with lib;

let cfg = config.custom.hardware.cpu;
in {
  options.custom.hardware.cpu = {
    intel.enable = mkEnableOption "Intel CPU support";
    freqGovernor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "powersave";
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
    (mkIf (cfg.freqGovernor != null) {
      powerManagement.cpuFreqGovernor = "${cfg.freqGovernor}";
    })
  ];
}
