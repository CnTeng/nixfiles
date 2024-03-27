{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.adb;
in
{
  options.programs'.adb.enable = mkEnableOption "adb";

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "adbusers" ];

    programs.adb.enable = true;

    home-manager.users.${user} = {
      home.packages = [ pkgs.android-studio ];
    };

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = [ ".android" ];
    };
  };
}
