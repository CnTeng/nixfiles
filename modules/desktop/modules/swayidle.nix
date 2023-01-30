{ pkgs, user, ... }:

let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
in
{
  home-manager.users.${user} = {
    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      events = [
        { event = "before-sleep"; command = "${playerctl} play-pause"; }
        { event = "before-sleep"; command = "${swaylock}"; }
      ];
      timeouts = [
        { timeout = 300; command = "${swaylock}"; }
        {
          timeout = 360;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }
      ];
    };
  };
}
