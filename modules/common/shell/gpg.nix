{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.gpg = {
      enable = true;
    };
  };
}
