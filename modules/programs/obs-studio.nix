{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.wlrobs
      ];
    };
  };
}
