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
        set -g status-position top
        set -g status-bg black
        set -g status-fg white 
        bind-key q set-option status

        # '@pane-is-vim' is a pane-local option that is set by the plugin on load,
        # and unset when Neovim exits or suspends; note that this means you'll probably
        # not want to lazy-load smart-splits.nvim, as the variable won't be set until
        # the plugin is loaded

        # Smart pane switching with awareness of Neovim splits.
        bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
        bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
        bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
        bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

        # Smart pane resizing with awareness of Neovim splits.
        bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
        bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
        bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
        bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
      '';
    };
  };
}
