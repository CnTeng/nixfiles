{ user, ... }:

{
  programs.kdeconnect.enable = true;

  home-manager.users.${user} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
