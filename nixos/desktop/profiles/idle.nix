{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.idleDaemon;

  playerctl = getExe pkgs.playerctl;
in {
  options.desktop'.profiles.idleDaemon.enable =
    mkEnableOption "idle daemon component";

  config = mkIf cfg.enable {
    security.pam.services.gtklock.text = "auth include login";

    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = (getExe' pkgs.systemd "systemctl") + " suspend";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = (getExe' pkgs.systemd "loginctl") + " lock-session";
          }
          {
            event = "lock";
            command = playerctl + " pause";
          }
          {
            event = "lock";
            command = getExe pkgs.gtklock + " -d";
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
