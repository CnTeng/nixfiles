{ user, ... }:
{
  home-manager.users.${user} = {
    programs.yazi = {
      enable = true;
      theme.status = {
        separator_open = "";
        separator_close = "";
      };
    };
  };
}
