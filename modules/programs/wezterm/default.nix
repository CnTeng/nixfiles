{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.wezterm = {
      enable = true;
    };

    xdg.configFile = {
      "wezterm/wezterm.lua" = {
        source = ./wezterm.lua;
        recursive = true;
      };
    };
  };
}
