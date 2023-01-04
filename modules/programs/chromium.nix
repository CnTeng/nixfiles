{ user, ... }:

{
  home-manager.users.${user} = {
    programs.chromium.enable = true;
  };
}
