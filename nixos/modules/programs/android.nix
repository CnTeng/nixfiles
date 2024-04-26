{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.android;
in
{
  options.programs'.android.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "adbusers" ];

    programs.adb.enable = true;

    home-manager.users.${user} = {
      home.packages = with pkgs; [ android-studio ];

      xdg.configFile."ideavim/ideavimrc".text = ''
        set relativenumber
        set number
        set commentary
        set showmode
        set NERDTree
        set clipboard+=unnamed

        let mapleader = ' '

        nmap <leader>w :<C-u>w<cr>
        nmap <leader>e :<C-u>NERDTreeToggle<cr>

        nmap <leader>b <Action>(Switcher)
        map <leader>lf <Action>(ReformatCode)

        nnoremap <c-h> <c-w>h
        nnoremap <c-j> <c-w>j
        nnoremap <c-k> <c-w>k
        nnoremap <c-l> <c-w>l
      '';
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".android"
        ".cache/Google"
        ".config/Google"
        ".local/share/Google"
        ".gradle"
        ".java"
      ];
    };
  };
}
