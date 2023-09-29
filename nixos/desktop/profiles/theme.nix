{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.theme;

  inherit (config.basics'.colors) flavour;
in {
  options.desktop'.profiles.theme.enable =
    mkEnableOption "custom gtk and qt theme";

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "gtk2";
    };

    home-manager.users.${user} = {
      systemd.user.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "gtk2";
        QT_STYLE_OVERRIDE = "gtk2";
      };

      home.pointerCursor = {
        package = pkgs.catppuccin-cursors."${toLower flavour}Dark";
        name = "Catppuccin-${flavour}-Dark-Cursors";
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        font.name = "Roboto";
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };

        theme = {
          package = pkgs.catppuccin-gtk.override {
            variant = toLower flavour;
            tweaks = ["rimless"];
          };
          name = "Catppuccin-${flavour}-Standard-Blue-Dark";
        };
      };
    };
  };
}
