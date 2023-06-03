{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.launcher;
  inherit (config.basics') colorScheme;
in {
  options.desktop'.components.launcher = {
    enable = mkEnableOption "launcher component" // {default = true;};
    package = mkPackageOption pkgs "launcher" {
      default = ["fuzzel"];
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "RobotoMono Nerd Font:size=15";
            dpi-aware = "no";
            icon-theme = "Papirus-Dark";
            lines = 5;
            width = 50;
          };
          colors = {
            background = "${colorScheme.base}e6";
            text = "${colorScheme.text}ff";
            match = "${colorScheme.blue}ff";
            selection = "${colorScheme.surface1}ff";
            selection-text = "${colorScheme.text}ff";
            selection-match = "${colorScheme.blue}ff";
            border = "${colorScheme.blue}e6";
          };
        };
      };
    };
  };
}
