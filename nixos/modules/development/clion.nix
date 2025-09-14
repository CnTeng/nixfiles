{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.clion;
in
{
  options.development'.clion.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {

    hm' =
      { config, ... }:
      {
        home.packages = [
          (pkgs.jetbrains.clion.override { forceWayland = true; })
        ];

        xdg.configFile."ideavim/ideavimrc".text = ''
          set clipboard+=unnamedplus
          set hlsearch
          set number
          set relativenumber
          set showmode

          set commentary
          set highlightedyank
          set NERDTree
          set which-key

          let mapleader = ' '

          nmap <C-s> :<C-u>w<cr>
          nmap <C-q> :<C-u>q<cr>
          nmap <leader>e :<C-u>NERDTreeToggle<cr>

          nmap <leader>b <Action>(Switcher)
          map <leader>lf <Action>(ReformatCode)

          nnoremap <C-h> <C-w>h
          nnoremap <C-j> <C-w>j
          nnoremap <C-k> <C-w>k
          nnoremap <C-l> <C-w>l
        '';

        home.sessionVariables = {
          _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
        };
      };

    preservation'.user.directories = [
      ".config/java"

      ".cache/JetBrains"
      ".config/JetBrains"
      ".local/share/JetBrains"
    ];
  };
}
