{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.cosmic.profiles.idle;
in
{
  options.cosmic.profiles.idle.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
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
      };
    };
  };
}
