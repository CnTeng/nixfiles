{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.jetbrains;

  android-studio = pkgs.android-studio.override { forceWayland = true; };
  clion = pkgs.jetbrains.clion.override { forceWayland = true; };
in
{
  options.development'.jetbrains = {
    android-studio.enable = lib.mkEnableOption "";
    clion.enable = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.android-studio.enable || cfg.clion.enable) {
    user'.extraGroups = lib.optionals cfg.android-studio.enable [ "adbusers" ];
    programs.adb.enable = cfg.android-studio.enable;

    hm' =
      { config, ... }:
      {
        home.packages =
          lib.optionals cfg.android-studio.enable [ android-studio ]
          ++ lib.optionals cfg.clion.enable [ clion ];

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
        }
        // lib.optionalAttrs cfg.android-studio.enable {
          ADB_VENDOR_KEY = "${config.xdg.configHome}/android";
          ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
          ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
        };
      };

    preservation'.user.directories = [
      ".config/java"
    ]
    ++ lib.optionals cfg.android-studio.enable [
      ".config/android"
      ".local/share/android"

      ".cache/Google"
      ".config/Google"
      ".local/share/Google"

      ".gradle"
    ]
    ++ lib.optionals cfg.clion.enable [
      ".cache/JetBrains"
      ".config/JetBrains"
      ".local/share/JetBrains"
    ];
  };
}
