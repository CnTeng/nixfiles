{ user, ... }:

{
  home-manager.users.${user} = {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
    };
  };
}
