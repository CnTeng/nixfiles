{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.android;
in
{
  options.programs'.android.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "adbusers" ];

    programs.adb.enable = true;

    home-manager.users.${user} = {
      home.packages = with pkgs; [ android-studio ];
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".android"
        ".cache/Google"
        ".config/Google"
        ".local/share/Google"
      ];
    };
  };
}
