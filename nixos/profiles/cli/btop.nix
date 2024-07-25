{ user, ... }:
{
  home-manager.users.${user} = {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };
  };
}
