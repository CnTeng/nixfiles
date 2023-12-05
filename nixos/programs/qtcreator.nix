{ config, lib, pkgs, themes, user, ... }:
with lib;
let
  cfg = config.programs'.qtcreator;

  inherit (themes) qtcreatorTheme;
in {
  options.programs'.qtcreator.enable = mkEnableOption "Qt Creator";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.qtcreator ];

      xdg.configFile = {
        "QtProject/qtcreator/styles".source = qtcreatorTheme + /styles;
        "QtProject/qtcreator/themes".source = qtcreatorTheme + /themes;
      };
    };
  };
}
