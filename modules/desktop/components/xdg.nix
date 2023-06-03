{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.xdg;
in {
  options.desktop'.components.xdg.enable =
    mkEnableOption "xdg component" // {default = true;};

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    home-manager.users.${user} = {
      xdg.enable = true;
      xdg.userDirs.enable = true;

      # For vscode and idea opening urls
      home.packages = [pkgs.xdg-utils];
    };
  };
}
