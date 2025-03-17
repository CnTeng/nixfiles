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
      services.megasync = {
        enable = true;
        forceWayland = true;
      };

      systemd.user.services.megasync = {
        Service = {
          Environment = [
            "USE_MEGASYNC_AS_REGULAR_WINDOW=1"
            "QT_STYLE_OVERRIDE="
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
