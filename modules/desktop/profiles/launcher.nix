{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.desktop'.profiles) palette;
in {
  options.desktop'.profiles.launcher = {
    enable = mkEnableOption "launcher component";
    package = mkPackageOption pkgs "launcher" {default = ["fuzzel"];};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "RobotoMono Nerd Font:size=13";
            dpi-aware = "no";
            icon-theme = "Papirus-Dark";
            lines = 5;
            width = 50;
          };
          colors = with palette; {
            background = "${removeHashTag base.hex}e6";
            text = "${removeHashTag text.hex}ff";
            match = "${removeHashTag blue.hex}ff";
            selection = "${removeHashTag surface1.hex}ff";
            selection-text = "${removeHashTag text.hex}ff";
            selection-match = "${removeHashTag blue.hex}ff";
            border = "${removeHashTag blue.hex}e6";
          };
        };
      };
    };
  };
}
