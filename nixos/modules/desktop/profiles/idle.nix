{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.profiles.idle;
in
{
  options.desktop'.profiles.idle.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    security.pam.services.gtklock = { };

    home-manager.users.${user} = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 240;
            command = (lib.getExe' pkgs.systemd "loginctl") + " lock-session";
          }
          {
            timeout = 300;
            command = (lib.getExe' pkgs.systemd "systemctl") + " suspend";
          }
        ];
        events = [
          {
            event = "lock";
            command = lib.getExe pkgs.playerctl + " pause";
          }
          {
            event = "lock";
            command = lib.getExe pkgs.gtklock + " -d -S";
          }
        ];
      };
    };
  };
}
