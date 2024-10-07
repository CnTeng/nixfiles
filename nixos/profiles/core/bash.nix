{ user, ... }:
{
  home-manager.users.${user} =
    { config, ... }:
    {
      programs.bash = {
        enable = true;
        historyFile = "${config.xdg.dataHome}/bash/bash_history";
      };
    };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/bash" ];
  };
}
