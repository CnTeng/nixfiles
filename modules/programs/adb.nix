{ pkgs, user, ... }:

{
  users.users.${user}.extraGroups = [ "adbusers" ];

  programs.adb.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
