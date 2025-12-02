{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellInit = /* fish */ ''
      set -U fish_greeting
    '';
  };

  environment.systemPackages = [ pkgs.fishPlugins.autopair ];

  user'.shell = pkgs.fish;

  hm'.programs.fish.enable = true;

  preservation'.user.directories = [ ".local/share/fish" ];
}
