{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.variables;
in {
  options.desktop'.profiles.variables.enable =
    mkEnableOption "Variables"
    // {
      default = true;
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

    home-manager.users.${user} = {
      # xresources.properties."Xft.dpi" = 120;
    };
  };
}
