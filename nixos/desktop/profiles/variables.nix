{ config, lib, ... }:
with lib;
let cfg = config.desktop'.profiles.variables;
in {
  options.desktop'.profiles.variables.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11";

      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      NIXOS_OZONE_WL = "1";
      XDG_SESSION_DESKTOP = "Hyprland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
}
