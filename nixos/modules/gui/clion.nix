{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.clion;
in
{
  options.gui'.clion.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [
        (pkgs.jetbrains.clion.override {
          vmopts = "-Dawt.toolkit.name=WLToolkit";
        })
      ];

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
        ".cache/JetBrains"
        ".config/JetBrains"
        ".local/share/JetBrains"
      ];
    };
  };
}
