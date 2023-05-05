{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.swayidle;

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
in {
  options.desktop'.components.swayidle.enable = mkEnableOption "swayidle";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = "${playerctl} play-pause";
          }
          {
            event = "before-sleep";
            command = "${swaylock}";
          }
        ];
        timeouts = [
          {
            timeout = 300;
            command = "${swaylock}";
          }
          {
            timeout = 360;
            command = "${hyprctl} dispatch dpms off";
            resumeCommand = "${hyprctl} dispatch dpms on";
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
