{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.idle;
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
            timeout = 240;
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
            command =
              (getExe pkgs.playerctl + " pause && ")
              + (getExe pkgs.gtklock + " -d -S -b ")
              + config.desktop'.profiles.wallpaper.image;
          }
        ];
      };
    };
  };
}
