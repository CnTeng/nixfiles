{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.desktop'.xdg;
in
{
  options.desktop'.xdg.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      xdg.userDirs.enable = true;
      xdg.mimeApps.enable = true;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Projects"
      ];
    };
  };

}
