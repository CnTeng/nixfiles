{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.idle;

  playerctl = getExe pkgs.playerctl;
in {
  options.desktop'.profiles.idle.enable =
    mkEnableOption "idle daemon component";

  config = mkIf cfg.enable {
    security.pam.services.gtklock = {};

    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 180;
            command = (getExe' pkgs.systemd "loginctl") + " lock-session";
          }
          {
            timeout = 300;
            command = (getExe' pkgs.systemd "systemctl") + " suspend";
          }
        ];
        events = [
          {
            event = "lock";
            command = playerctl + " pause";
          }
          {
            event = "lock";
            command =
              getExe pkgs.gtklock
              + " -d -S -b "
              + config.desktop'.profiles.wallpaper.image;
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
