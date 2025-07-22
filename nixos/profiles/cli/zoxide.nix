{ config, ... }:
let
  inherit (config.core') user;
in
{
  home-manager.users.${user} = {
    programs.zoxide.enable = true;
  };

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".local/share/zoxide" ];
  };
}
