{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.theme;
in
{
  options.desktop'.theme.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        home.pointerCursor = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
          gtk.enable = true;
        };

        qt = {
          enable = true;
          style.name = "adwaita-dark";
        };

        gtk = {
          enable = true;
          font.name = "Noto Sans";
          iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
          };
          theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3-dark";
          };
          gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
      };
  };
}
