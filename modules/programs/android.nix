{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.android;
in {
  options.programs'.android.enable =
    mkEnableOption "Android development support";

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "adbusers" ];
    programs.adb.enable = true;
    services.udev.packages = [ pkgs.android-udev-rules ];
  };
}
