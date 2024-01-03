# TODO: finsh tmux config
{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.utils'.tmux;
in {
  options.utils'.tmux.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zellij.enable = true;

      programs.tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 50;
        keyMode = "vi";
        mouse = true;
        prefix = "M-`";
        terminal = "screen-256color";
        reverseSplit = true;
        extraConfig = ''
          set -ag terminal-overrides ",xterm-256color:RGB"

          unbind n
          unbind p
          unbind 1
          unbind 2
          unbind 3
          unbind 4
          unbind 5
          unbind 6
          unbind 7
          unbind 8
          unbind 9
          unbind 0
          bind -r C-p previous-window
          bind -r C-n next-window

          bind -n M-1 select-window -t 1
          bind -n M-2 select-window -t 2
          bind -n M-3 select-window -t 3
          bind -n M-4 select-window -t 4
          bind -n M-5 select-window -t 5
          bind -n M-6 select-window -t 6
          bind -n M-7 select-window -t 7
          bind -n M-8 select-window -t 8
          bind -n M-9 select-window -t 9


          # Smart pane switching with awareness of Vim splits.
          # See: https://github.com/christoomey/vim-tmux-navigator
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
          bind-key -n C-h if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n C-j if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
          bind-key -n C-k if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
          bind-key -n C-l if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

          bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
          bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
          bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
          bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'

          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
          if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
          if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R
          bind-key -T copy-mode-vi 'C-\' select-pane -l
        '';
        plugins = with pkgs.tmuxPlugins; [{
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_l_left_separator "█"
            set -g @catppuccin_l_right_separator "█"
            set -g @catppuccin_r_left_separator "█"
            set -g @catppuccin_r_right_separator "█"

            # set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_user "on"
            set -g @catppuccin_host "on"
          '';
        }];
      };
    };
  };
}
