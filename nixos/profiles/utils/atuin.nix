{ user, ... }:
{
  home-manager.users.${user} = {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "https://atuin.snakepi.xyz";
        style = "compact";
        sync.records = true;
      };
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/atuin" ];
  };
}
