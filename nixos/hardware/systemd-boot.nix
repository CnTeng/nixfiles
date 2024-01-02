{ config, lib, ... }:
with lib;
let cfg = config.hardware'.systemd-boot;
in {
  options.hardware'.systemd-boot.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.systemd-boot.enable = true;
  };
}
