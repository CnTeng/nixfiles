{ config, user, ... }:

{
  services.onedrive.enable = true;

  home-manager.users.${user} = {
    services.dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };
}
