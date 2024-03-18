# TODO: finsh tmux config
{ user, ... }:
{
  environment.persistence."/persist" = {
    users.${user}.directories = [ ".cache/zellij" ];
  };

  home-manager.users.${user} = {
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

        # '@pane-is-vim' is a pane-local option that is set by the plugin on load,
        # and unset when Neovim exits or suspends; note that this means you'll probably
        # not want to lazy-load smart-splits.nvim, as the variable won't be set until
        # the plugin is loaded

        # Smart pane switching with awareness of Neovim splits.
        bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
        bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
        bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
        bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'

        # Smart pane resizing with awareness of Neovim splits.
        bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
        bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
        bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
        bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

        bind-key -n C-\ if -F "#{@pane-is-vim}" 'send-keys C-\\' 'select-pane -l'"

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };
  };
}
