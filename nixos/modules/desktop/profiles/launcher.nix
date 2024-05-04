{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.desktop'.profiles) palette;
in
{
  options.desktop'.profiles.launcher.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
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
              background = lib.removeHashTag dark_0 + "e6";
              text = lib.removeHashTag light_1 + "ff";
              match = lib.removeHashTag blue_1 + "ff";
              selection = lib.removeHashTag dark_1 + "ff";
              selection-text = lib.removeHashTag light_1 + "ff";
              selection-match = lib.removeHashTag blue_1 + "ff";
              border = lib.removeHashTag light_1 + "e6";
            };
          };
        };

        wayland.windowManager.sway.config.menu = lib.getExe config.programs.fuzzel.package;
      };

    environment.persistence."/persist" = {
      users.${user}.files = [ ".cache/fuzzel" ];
    };
  };
}
