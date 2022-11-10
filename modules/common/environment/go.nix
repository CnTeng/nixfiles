{ user, ... }:

{
  home-manager.users.${user} = {
    programs.go = {
      enable = true;
      goPath = "go";
    };
  };
}
