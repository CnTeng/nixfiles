{ user, ... }:
{
  home-manager.users.${user} = {
    services.udiskie.enable = true;
  };
}
