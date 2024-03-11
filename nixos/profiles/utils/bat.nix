{ user, ... }:
{

  home-manager.users.${user} = {
    programs.bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".cache/bat" ];
  };
}
