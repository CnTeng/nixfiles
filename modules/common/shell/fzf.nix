{ user, ... }:

# TODO:finsh fzf config
{
  home-manager.users.${user} = {
    programs.fzf = {
      enable = true;
    };
  };
}
