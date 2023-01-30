{ ... }:

# TODO:finsh tmux config
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
  };
}
