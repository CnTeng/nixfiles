{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.idleDaemon;

  locker = getExe config.desktop'.profiles.locker.package;
  playerctl = getExe pkgs.playerctl;
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in {
  options.desktop'.profiles.idleDaemon.enable =
    mkEnableOption "idle daemon component";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = locker;
          }
          {
            timeout = 360;
            command = "${hyprctl} dispatch dpms off";
            resumeCommand = "${hyprctl} dispatch dpms on";
          }
        ];
        events = [
          {
            event = "lock";
            command = "${playerctl} play-pause";
          }
          {
            event = "lock";
            command = locker;
          }
          {
            event = "before-sleep";
            command = "${playerctl} play-pause";
          }
          {
            event = "before-sleep";
            command = locker;
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
