{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.profiles.theme;

  inherit (config.basics'.colors) flavour;
in {
  options.desktop'.profiles.theme.enable =
    mkEnableOption "custom gtk and qt theme";

  config = mkIf cfg.enable {
    boot = {
      initrd.verbose = false;
      consoleLogLevel = 0;
      kernelParams = [ "quiet" "udev.log_level=3" ];

      plymouth = {
        enable = true;
        themePackages = [
          (pkgs.catppuccin-plymouth.override { variant = toLower flavour; })
        ];
        theme = "catppuccin-${toLower flavour}";
      };
    };

    home-manager.users.${user} = {
      qt.enable = true;

      home.pointerCursor = {
        package = pkgs.catppuccin-cursors."${toLower flavour}Dark";
        name = "Catppuccin-${flavour}-Dark-Cursors";
        gtk.enable = true;
      };

      gtk = let
        theme = {
          package = pkgs.catppuccin-gtk.override {
            variant = toLower flavour;
            tweaks = [ "rimless" ];
          };
          name = "Catppuccin-${flavour}-Standard-Blue-Dark";
        };
      in {
        enable = true;
        font.name = "Roboto";
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };

        inherit theme;
      };
      home.file = let
        theme = {
          package = pkgs.catppuccin-gtk.override {
            variant = toLower flavour;
            tweaks = [ "rimless" ];
          };
          name = "Catppuccin-${flavour}-Standard-Blue-Dark";
        };
      in {
        ".config/gtk-4.0/gtk.css".source =
          "${theme.package}/share/themes/${theme.name}/gtk-4.0/gtk.css";
        ".config/gtk-4.0/gtk-dark.css".source =
          "${theme.package}/share/themes/${theme.name}/gtk-4.0/gtk-dark.css";

        ".config/gtk-4.0/assets" = {
          recursive = true;
          source = "${theme.package}/share/themes/${theme.name}/gtk-4.0/assets";
        };
      };
      # home.sessionVariables.GTK_THEME = "Catppuccin-${flavour}-Standard-Blue-Dark";
    };
  };
}
