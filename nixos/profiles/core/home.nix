{
  config,
  inputs,
  user,
  ...
}:
let
  inherit (config.users.users.${user}) home;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.${user} = {
    home.stateVersion = config.system.stateVersion;

    xdg.enable = true;

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

      "OneDrive"
      ".config/onedrive"
    ];
  };
}
