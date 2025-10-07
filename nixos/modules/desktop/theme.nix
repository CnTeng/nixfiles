{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.theme;
in
{
  options.desktop'.theme.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' =
      { config, ... }:
      {
        home.pointerCursor = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
          gtk.enable = true;
          dotIcons.enable = false;
        };

        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita-dark";
        };

        gtk = {
          enable = true;
          font.name = "Adwaita Sans";
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
