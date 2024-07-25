{ user, ... }:
{
  home-manager.users.${user} = {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "https://atuin.snakepi.xyz";
        inline_height = 30;
        keymap_mode = "vim-normal";
        sync.records = true;
      };
    };
  };

  environment.persistence."/persist" = {
    users.${user}.directories = [ ".local/share/atuin" ];
  };
}
