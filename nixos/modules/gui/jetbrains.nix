{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.jetbrains;

  android-studio = pkgs.android-studio.override { forceWayland = true; };
  clion = pkgs.jetbrains.clion.override { vmopts = "-Dawt.toolkit.name=WLToolkit"; };
in
{
  options.gui'.jetbrains = {
    android-studio.enable = lib.mkEnableOption' { };
    clion.enable = lib.mkEnableOption' { };
  };

  config = lib.mkIf (cfg.android-studio.enable || cfg.clion.enable) {
    users.users.${user}.extraGroups = lib.optionals cfg.android-studio.enable [ "adbusers" ];
    programs.adb.enable = cfg.android-studio.enable;

    home-manager.users.${user} =
      { config, ... }:
      {
        home.packages =
          lib.optionals cfg.android-studio.enable [ android-studio ]
          ++ lib.optionals cfg.clion.enable [ clion ];

        xdg.configFile."ideavim/ideavimrc".text = ''
          set number
          set relativenumber
          set showmode
          set clipboard+=unnamed

          set commentary
          set highlightedyank
          set NERDTree
          set which-key

          let mapleader = ' '

          nmap <c-s> :<C-u>w<cr>
          nmap <leader>e :<C-u>NERDTreeToggle<cr>

          nmap <leader>b <Action>(Switcher)
          map <leader>lf <Action>(ReformatCode)

          nnoremap <c-h> <c-w>h
          nnoremap <c-j> <c-w>j
          nnoremap <c-k> <c-w>k
          nnoremap <c-l> <c-w>l
        '';

        home.sessionVariables =
          {
            _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
          }
          // lib.optionalAttrs cfg.android-studio.enable {
            ADB_VENDOR_KEY = "${config.xdg.configHome}/android";
            ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
            ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
          };
      };

    preservation.preserveAt."/persist" = {
      users.${user}.directories =
        [ ".config/java" ]
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
  };
}
