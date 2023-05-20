{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop'.components.variables;
in {
  options.desktop'.components.variables.enable = mkEnableOption "Variables";

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      GDK_DPI_SCALE = "1.25";
      GDK_BACKEND = "wayland,x11";

      # QT_SCALE_FACTOR = "1.25";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      NIXOS_OZONE_WL = "0"; # Vscode need to run under xwayland to use fcitx5
      XDG_SESSION_DESKTOP = "Hyprland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
}
