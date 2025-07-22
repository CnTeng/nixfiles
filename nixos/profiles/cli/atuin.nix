{ config, ... }:
let
  inherit (config.core') user;
in
{
  home-manager.users.${user} = {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "https://atuin.snakepi.xyz";
        workspaces = true;
        inline_height = 30;
        sync.records = true;
      };
      daemon.enable = true;
    };
  };

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".local/share/atuin" ];
  };
}
