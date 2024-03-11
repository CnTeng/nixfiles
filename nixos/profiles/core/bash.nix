{ user, ... }:
{
  programs.bash.blesh.enable = true;

  home-manager.users.${user} = {
    programs.bash.enable = true;
  };

  environment.persistence."/persist" = {
    users.${user} = {
      files = [ ".bash_history" ];
      directories = [ ".cache/blesh" ];
    };
  };
}
