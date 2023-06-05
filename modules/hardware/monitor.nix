{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.hardware'.monitor;
in {
  options.hardware'.monitor.enable = mkEnableOption "monitor DDC support";

  config = mkIf cfg.enable {
    hardware.i2c.enable = true;

    users.users.${user}.extraGroups = ["i2c"];

    environment.systemPackages = [pkgs.ddcutil];
  };
}
