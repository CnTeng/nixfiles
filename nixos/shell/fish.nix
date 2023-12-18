{ config, lib, pkgs, user, themes, ... }:
with lib;
let
  cfg = config.shell'.fish;

  inherit (config.core'.colors) flavour;
  inherit (themes) fishTheme;
in {
  options.shell'.fish.enable = mkEnableOption' { default = true; };

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
        plugins = [{
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }];
        interactiveShellInit = ''
          fish_config theme choose "Catppuccin ${flavour}"
        '';
      };
      xdg.configFile."fish/themes".source = "${fishTheme}/themes";
    };
  };
}
