{
  config,
  lib,
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

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = [ ".android" ];
    };
  };
}
