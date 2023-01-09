{ user, ... }:

{
  home-manager.users.${user} = {
    programs.tmux = {
      enable = true;
    };
  };
}
