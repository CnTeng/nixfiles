{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.custom.desktop.components.theme;
  inherit (cfg) modules;
in {
  options.custom.desktop.components.theme = {
    enable = mkEnableOption "custom gtk and qt theme";

    modules = mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // { default = cfg.enable; }) {
        gtk = "custom gtk theme";
        qt = "custom qt theme";
      };
  };

  config = mkIf cfg.enable {
    qt = mkIf modules.qt {
      enable = true;
      platformTheme = "qt5ct";
    };

    home-manager.users.${user} = {
      # Set the qt theme by using kvantum
      home.packages = mkIf modules.qt (with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        (catppuccin-kvantum.override { variant = "Macchiato"; })
      ]);

      # Set the theme of cursor for the whole system
      home.pointerCursor = mkIf modules.gtk {
        name = "Catppuccin-Macchiato-Dark-Cursors";
        package = pkgs.catppuccin-cursors.macchiatoDark;
        size = 32;
        gtk.enable = true;
        x11.enable = true;
      };

      # Set the gtk theme
      gtk = mkIf modules.gtk {
        enable = true;
        theme = {
          name = "Catppuccin-Macchiato-Standard-Blue-Dark";
          package = pkgs.catppuccin-gtk.override {
            variant = "macchiato";
            tweaks = [ "rimless" ];
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        font = { name = "Roboto"; };
      };
    };
  };
}
