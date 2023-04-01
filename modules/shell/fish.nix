{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.shell'.fish;
  inherit (config.basics') colorScheme;
in {
  options.shell'.fish.enable = mkEnableOption "fish" // { default = true; };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      useBabelfish = true;
      shellInit = ''
        set -U fish_greeting
      '';
    };

    users.users.${user}.shell = pkgs.fish;

    environment.pathsToLink = [ "/share/fish" ];

    home-manager.users.${user} = {
      programs.fish = {
        enable = true;
        plugins = [ ];
        interactiveShellInit = ''
          fish_config theme choose "Catppuccin Macchiato"
        '';
      };
      # Copy from https://github.com/catppuccin/fish
      xdg.configFile."fish/themes/Catppuccin Macchiato.theme".text = ''
        fish_color_normal ${colorScheme.text}
        fish_color_command ${colorScheme.blue}
        fish_color_param ${colorScheme.flamingo}
        fish_color_keyword ${colorScheme.red}
        fish_color_quote ${colorScheme.green}
        fish_color_redirection ${colorScheme.pink}
        fish_color_end ${colorScheme.peach}
        fish_color_comment ${colorScheme.overlay1}
        fish_color_error ${colorScheme.red}
        fish_color_gray ${colorScheme.overlay0}
        fish_color_selection --background=${colorScheme.surface0}
        fish_color_search_match --background=${colorScheme.surface0}
        fish_color_operator ${colorScheme.pink}
        fish_color_escape ${colorScheme.maroon}
        fish_color_autosuggestion ${colorScheme.overlay0}
        fish_color_cancel ${colorScheme.red}
        fish_color_cwd ${colorScheme.yellow}
        fish_color_user ${colorScheme.teal}
        fish_color_host ${colorScheme.blue}
        fish_color_host_remote ${colorScheme.green}
        fish_color_status ${colorScheme.red}
        fish_pager_color_progress ${colorScheme.overlay0}
        fish_pager_color_prefix ${colorScheme.pink}
        fish_pager_color_completion ${colorScheme.text}
        fish_pager_color_description ${colorScheme.overlay0}
      '';
    };
  };
}
