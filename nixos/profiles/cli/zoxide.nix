{ user, ... }:
{
  home-manager.users.${user} = {
    programs.zoxide.enable = true;
  };

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".local/share/zoxide" ];
  };
}
