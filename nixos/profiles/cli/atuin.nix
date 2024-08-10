{ user, ... }:
{
  home-manager.users.${user} = {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "https://atuin.snakepi.xyz";
        workspaces = true;
        inline_height = 30;
        keymap_mode = "vim-normal";
        keymap_cursor = {
          emacs = "blink-bar";
          vim_insert = "blink-bar";
          vim_normal = "steady-block";
        };
        sync.records = true;
      };
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/atuin" ];
  };
}
