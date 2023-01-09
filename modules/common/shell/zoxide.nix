{ user, ... }:

{
  home-manager.users.${user} = {
    programs.zoxide = {
      enable = true;
    };
  };
}
