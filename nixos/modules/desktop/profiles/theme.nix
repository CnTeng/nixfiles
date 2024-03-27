{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.theme;
in
{
  options.desktop'.profiles.theme.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    # boot.initrd.verbose = false;
    # boot.consoleLogLevel = 0;
    # boot.kernelParams = [
    #   "quiet"
    #   "udev.log_level=3"
    # ];

    home-manager.users.${user} = {
      home.pointerCursor = {
        package = pkgs.gnome.adwaita-icon-theme;
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
        font.name = "Roboto";
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
        theme = {
          package = pkgs.adw-gtk3;
          name = "adw-gtk3-dark";
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };
}
