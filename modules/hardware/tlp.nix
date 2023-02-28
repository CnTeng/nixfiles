{ config, lib, ... }:

with lib;

let cfg = config.custom.hardware.power;
in {
  options.custom.hardware.power = {
    tlp.enable = mkEnableOption "tlp support";
    acpi_call.enable = mkEnableOption "acpi_call support" // {
      default = cfg.tlp.enable;
    };
  };

  config = mkMerge [
    (mkIf cfg.tlp.enable {
      services = {
        tlp.enable = true;
        auto-cpufreq.enable = true;
        thermald.enable = true;
      };
    })
    (mkIf cfg.acpi_call.enable {
      boot = {
        kernelModules = [ "acpi_call" ];
        extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
      };
    })
  ];
}
