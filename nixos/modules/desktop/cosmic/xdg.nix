{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cosmic.profiles.xdg;
in
{
  options.cosmic.profiles.xdg.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.onedrive.enable = true;

    systemd.user.services.onedrive-launcher = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = lib.mkForce [ "graphical-session.target" ];
    };

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
        "OneDrive"
        ".config/onedrive"
      ];
    };
  };
}
