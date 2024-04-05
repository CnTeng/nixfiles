{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.sioyek;
in
{
  options.programs'.sioyek.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.sioyek.enable = true;

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "sioyek.desktop";
      };
    };
  };
}
