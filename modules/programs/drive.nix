{ config, user, ... }:

let
  homeDirectory = config.home-manager.users.${user}.home.homeDirectory;
in
{
  services.onedrive.enable = true;

  home-manager.users.${user} = {
    services.dropbox = {
      enable = true;
      path = "${homeDirectory}/Dropbox";
    };
  };
}
