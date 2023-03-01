{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.android;
in {
  options.custom.programs.android = {
    enable = mkEnableOption "Android development support";
    adb.enable = mkEnableOption "adb" // { default = cfg.enable; };
    studio.enable = mkEnableOption "Android Studio" // {
      default = cfg.enable;
    };
  };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = mkIf cfg.adb.enable [ "adbusers" ];
    programs.adb.enable = mkIf cfg.adb.enable true;
    services.udev.packages = mkIf cfg.adb.enable [ pkgs.android-udev-rules ];

    home-manager.users.${user} = {
      home.packages = with pkgs;
        mkIf cfg.studio.enable [
          (android-studio.override {
            tiling_wm = true;
            nss = pkgs.nss_latest; # Fix can't open url
          })
          kotlin
        ];
    };
  };
}
