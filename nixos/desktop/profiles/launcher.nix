{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.core'.colors) palette;
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
              lines = 5;
              width = 50;
            };
            colors = with palette; {
              background = removeHashTag base.hex + "e6";
              text = removeHashTag text.hex + "ff";
              match = removeHashTag blue.hex + "ff";
              selection = removeHashTag surface1.hex + "ff";
              selection-text = removeHashTag text.hex + "ff";
              selection-match = removeHashTag blue.hex + "ff";
              border = removeHashTag text.hex + "e6";
            };
            key-bindings = {
              cancel = "Control+bracketleft Escape";
              delete-line = "none";
              prev = "Up Control+p Control+k";
              next = "Down Control+n Control+j";
            };
          };
        };

        wayland.windowManager.sway.config.menu = getExe config.programs.fuzzel.package;
      };
  };
}
