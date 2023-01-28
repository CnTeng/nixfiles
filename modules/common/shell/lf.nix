{ user, ... }:

{
  home-manager.users.${user} = {
    programs.lf = {
      enable = true;
    };
  };
}
