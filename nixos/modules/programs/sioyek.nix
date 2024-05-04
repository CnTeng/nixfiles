{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.programs'.sioyek;
in
{
  options.programs'.sioyek.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.sioyek = {
        enable = true;
        config = {
          should_launch_new_window = "1";
        };
      };

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "sioyek.desktop";
      };
    };
  };
}
