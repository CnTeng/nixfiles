{ config, lib, pkgs, themes, user, ... }:
with lib;
let
  cfg = config.programs'.qtcreator;

  inherit (themes) qtcreatorTheme;
in {
  options.programs'.qtcreator.enable = mkEnableOption "Qt Creator";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs;
        [
          (qtcreator.override {
            llvmPackages = llvmPackages_17;
            qttools = qt6.qttools.override { llvmPackages = llvmPackages_17; };
          })
        ];

      xdg.configFile = {
        "QtProject/qtcreator/styles".source = qtcreatorTheme + /styles;
        "QtProject/qtcreator/themes".source = qtcreatorTheme + /themes;
      };
    };
  };
}
