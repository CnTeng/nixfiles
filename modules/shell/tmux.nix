# TODO: finsh tmux config
{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.tmux;
in {
  options.shell'.tmux.enable = mkEnableOption "tmux" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zellij.enable = true;

      programs.tmux = {
        enable = true;
        keyMode = "vi";
        # terminal = "";
        extraConfig = ''
          set -g default-terminal "tmux-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"
        '';
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_window_tabs_enabled on
              set -g @catppuccin_flavour 'macchiato'
              set -g @catppuccin_left_separator "█"
              set -g @catppuccin_right_separator "█"
            '';
          }
        ];
      };
    };
  };
}
