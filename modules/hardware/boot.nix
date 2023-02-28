{ config, lib, ... }:

with lib;

let cfg = config.custom.hardware.boot;
in {
  options.custom.hardware.boot = { enable = mkEnableOption "Systemd-boot"; };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        systemd-boot = {
          enable = true;
          consoleMode = "keep";
        };
        timeout = 1;
      };
      plymouth.enable = true;
    };
  };
}
