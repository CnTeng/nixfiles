{
  inputs,
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.fish;
  inherit (inputs.catppuccin) fishCat;
in {
  options.shell'.fish.enable = mkEnableOption "fish" // {default = true;};

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
        interactiveShellInit = ''
          fish_vi_key_bindings
          set fish_cursor_default block blink
          set fish_cursor_insert line blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual block

          fish_config theme choose "Catppuccin Macchiato"
        '';
      };
      xdg.configFile."fish/themes".source = "${fishCat}/themes";
    };
  };
}
