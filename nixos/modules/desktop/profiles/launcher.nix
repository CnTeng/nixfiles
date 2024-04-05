{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.desktop'.profiles) palette;
in
{
  options.desktop'.profiles.launcher.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              font = "RobotoMono Nerd Font:size=15";
              icon-theme = "Papirus-Dark";
              anchor = "top";
              lines = 5;
              width = 50;
            };
            colors = with palette; {
              background = removeHashTag dark_0 + "e6";
              text = removeHashTag light_1 + "ff";
              match = removeHashTag blue_1 + "ff";
              selection = removeHashTag dark_1 + "ff";
              selection-text = removeHashTag light_1 + "ff";
              selection-match = removeHashTag blue_1 + "ff";
              border = removeHashTag light_1 + "e6";
            };
          };
        };

        wayland.windowManager.sway.config.menu = getExe config.programs.fuzzel.package;
      };

    environment.persistence."/persist" = {
      users.${user}.files = [ ".cache/fuzzel" ];
    };
  };
}
