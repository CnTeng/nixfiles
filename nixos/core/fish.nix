{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.core'.fish;
in
{
  options.core'.fish.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      useBabelfish = true;
      shellInit = ''
        set -U fish_greeting
      '';
    };

    users.users.${user}.shell = pkgs.fish;

    home-manager.users.${user} = {
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "fzf-fish";
            inherit (pkgs.fishPlugins.fzf-fish) src;
          }
        ];
      };
    };
  };
}
