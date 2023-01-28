{ user, ... }:

{
  home-manager.users.${user} = {
    programs.feh = {
      enable = true;
    };
  };
}
