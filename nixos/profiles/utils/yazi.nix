{ user, ... }:
{
  home-manager.users.${user} = {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
