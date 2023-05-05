{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.theme;
  inherit (cfg) modules;
in {
  options.desktop'.components.theme = {
    enable = mkEnableOption "custom gtk and qt theme";

    modules =
      mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // {default = cfg.enable;}) {
        gtk = "custom gtk theme";
        qt = "custom qt theme";
      };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      qt = mkIf modules.qt {
        enable = true;
        platformTheme = "gtk";
        style.name = "gtk2";
      };

      # Set the theme of cursor for the whole system
      home.pointerCursor = mkIf modules.gtk {
        package = pkgs.catppuccin-cursors.macchiatoDark;
        name = "Catppuccin-Macchiato-Dark-Cursors";
        size = 32;
        gtk.enable = true;
      };

      # Set the gtk theme
      gtk = mkIf modules.gtk {
        enable = true;
        font.name = "Roboto";
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
        theme = {
          package = pkgs.catppuccin-gtk.override {
            variant = "macchiato";
            tweaks = ["rimless"];
          };
          name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        };
        gtk2.configLocation = "${config.home-manager.users.${user}.xdg.configHome}/gtk-2.0/gtkrc";
      };

      xdg.configFile = {
        "gtk-4.0/assets" = {
          source = "${
            config.home-manager.users.${user}.gtk.theme.package
          }/share/themes/Catppuccin-Macchiato-Standard-Blue-Dark/gtk-4.0/assets";
          recursive = true;
        };

        "gtk-4.0/gtk.css".source = "${
          config.home-manager.users.${user}.gtk.theme.package
        }/share/themes/Catppuccin-Macchiato-Standard-Blue-Dark/gtk-4.0/gtk.css";

        "gtk-4.0/gtk-dark.css".source = "${
          config.home-manager.users.${user}.gtk.theme.package
        }/share/themes/Catppuccin-Macchiato-Standard-Blue-Dark/gtk-4.0/gtk-dark.css";
      };
    };
  };
}
