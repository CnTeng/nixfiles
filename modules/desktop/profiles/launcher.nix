{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.desktop'.profiles) colorScheme;
in {
  options.desktop'.profiles.launcher = {
    enable = mkEnableOption "launcher component" // {default = true;};
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
          colors = with colorScheme; {
            background = "${removeHashTag base}e6";
            text = "${removeHashTag text}ff";
            match = "${removeHashTag blue}ff";
            selection = "${removeHashTag surface1}ff";
            selection-text = "${removeHashTag text}ff";
            selection-match = "${removeHashTag blue}ff";
            border = "${removeHashTag blue}e6";
          };
        };
      };
    };
  };
}
