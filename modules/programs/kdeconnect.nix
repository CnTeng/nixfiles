{ user, ... }:

{
  home-manager.users.${user} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
