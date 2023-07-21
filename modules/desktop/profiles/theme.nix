{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.theme;
  inherit (cfg) modules;
in {
  options.desktop'.profiles.theme = {
    enable = mkEnableOption "custom gtk and qt theme" // {default = true;};

    modules =
      mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // {default = cfg.enable;}) {
        gtk = "custom gtk theme";
        qt = "custom qt theme";
      };
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = ["/share/Kvantum"];

    home-manager.users.${user} = let
      inherit (config.home-manager.users.${user}.gtk.theme) package name;
    in {
      home.packages = [
        (pkgs.catppuccin-kvantum.override {variant = "Mocha";})
      ];
      qt = mkIf modules.qt {
        enable = true;
        platformTheme = "qtct";
        style.name = "kvantum";
      };

      # Set the theme of cursor for the whole system
      home.pointerCursor = mkIf modules.gtk {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark-Cursors";
        # size = 32;
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
            variant = "mocha";
            tweaks = ["rimless"];
          };
          name = "Catppuccin-Mocha-Standard-Blue-Dark";
        };

        gtk2.configLocation = "${config.home-manager.users.${user}.xdg.configHome}/gtk-2.0/gtkrc";

        gtk4.extraCss = readFile "${package}/share/themes/${name}/gtk-4.0/gtk.css";
      };
    };
  };
}
