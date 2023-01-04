{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
