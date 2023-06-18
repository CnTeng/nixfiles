{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.components.idle;

  locker = getExe config.desktop'.components.locker.package;
  playerctl = getExe pkgs.playerctl;
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in {
  options.desktop'.components.idle.enable =
    mkEnableOption "idle daemon component" // {
      default = config.desktop'.hyprland.enable;
    };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "${locker}";
          }
          {
            timeout = 360;
            command = "${hyprctl} dispatch dpms off";
            resumeCommand = "${hyprctl} dispatch dpms on";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${playerctl} play-pause";
          }
          {
            event = "before-sleep";
            command = "${locker}";
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
