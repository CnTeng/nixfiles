{ config, lib, user, ... }:
with lib;
let cfg = config.desktop'.components.variables;
in {
  options.desktop'.components.variables.enable = mkEnableOption "Variables" // {
    default = config.desktop'.hyprland.enable;
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      NIXOS_OZONE_WL =
        mkForce "0"; # Vscode need to run under xwayland to use fcitx5
      XDG_SESSION_DESKTOP = "Hyprland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

    # home-manager.users.${user} = {
    #   dconf.settings."org/gnome/desktop/interface".text-scaling-factor = 1.25;
    #   systemd.user.sessionVariables.QT_WAYLAND_FORCE_DPI = 120;
    #   xresources.properties."Xft.dpi" = 120;
    # };
  };
}
