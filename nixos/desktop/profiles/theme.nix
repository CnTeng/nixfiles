{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.profiles.theme;

  inherit (config.core'.colors) flavour;
in {
  options.desktop'.profiles.theme.enable = mkEnableOption' { };

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
            tweaks = [ "rimless" ];
          };
          name = "Catppuccin-${flavour}-Standard-Blue-Dark";
        };
      };

      # home.sessionVariables.GTK_THEME = "Catppuccin-${flavour}-Standard-Blue-Dark";
    };
  };
}
