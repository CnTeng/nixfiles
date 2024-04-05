{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.xdg;
in
{
  options.desktop'.profiles.xdg.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      let
        onedrive = "${config.home.homeDirectory}/OneDrive";
      in
      {
        xdg.enable = true;

        xdg.userDirs = {
          enable = true;
          desktop = null;
          documents = "${onedrive}/Documents";
          music = null;
          publicShare = null;
          templates = null;
          pictures = "${onedrive}/Pictures";
          videos = "${onedrive}/Videos";
        };

        xdg.mimeApps.enable = true;
      };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        "Downloads"
        "Projects"
      ];
    };
  };
}
