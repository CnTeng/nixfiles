{ pkgs, user, ... }:
{
  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellInit = ''
      set -U fish_greeting
    '';
  };

  environment.systemPackages = with pkgs.fishPlugins; [
    fzf-fish
    autopair
  ];

  users.users.${user}.shell = pkgs.fish;

  home-manager.users.${user} = {
    programs.fish.enable = true;
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/fish" ];
  };
}
