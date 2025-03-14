{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.megasync;
in
{
  options.gui'.megasync.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      services.megasync.enable = true;

      systemd.user.services.megasync = {
        Service = {
          Environment = [
            "DO_NOT_UNSET_XDG_SESSION_TYPE=1"
            "DO_NOT_UNSET_QT_QPA_PLATFORMTHEME=1"
            "USE_MEGASYNC_AS_REGULAR_WINDOW=1"
          ];
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 3";
        };
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".local/share/data" ];
    };
  };
}
