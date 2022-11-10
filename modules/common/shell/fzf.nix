{ user, ... }:

{
  home-manager.users.${user} = {
    programs.fzf = {
      enable = true;
    };
  };
}
