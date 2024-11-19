{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.desktop'.xdg;
  inherit (config.users.users.${user}) home;
in
{
  options.desktop'.xdg.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      xdg.userDirs = {
        enable = true;
        desktop = null;
        documents = "${home}/Documents";
        download = "${home}/Inbox";
        music = null;
        pictures = "${home}/Pictures";
        publicShare = null;
        templates = null;
        videos = null;
        extraConfig = {
          XDG_ARCHIVES_DIR = "${home}/Archives";
          XDG_PROJECTS_DIR = "${home}/Projects";
        };
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        "Archives"
        "Documents"
        "Inbox"
        "Pictures"
        "Projects"
      ];
    };
  };

}
