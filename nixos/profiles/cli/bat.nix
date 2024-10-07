{ user, ... }:
{

  home-manager.users.${user} = {
    programs.bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };
  };

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".cache/bat" ];
  };
}
