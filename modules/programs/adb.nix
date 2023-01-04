{ pkgs, user, ... }:

{
  users.users.${user}.extraGroups = [ "adbusers" ];

  programs.adb.enable = true;

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
}
