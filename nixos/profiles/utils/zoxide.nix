{ user, ... }:
{
  home-manager.users.${user} = {
    programs.zoxide.enable = true;
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/zoxide" ];
  };
}
