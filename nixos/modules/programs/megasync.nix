{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.megasync;
in
{
  options.programs'.megasync.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
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

    preservation'.user.directories = [ ".local/share/data" ];
  };
}
