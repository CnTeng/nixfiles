{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.jetbrains;
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
          lib.optionals cfg.android-studio.enable [
            (pkgs.android-studio.override {
              forceWayland = true;
            })
          ]
          ++ lib.optionals cfg.clion.enable [
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

    environment.persistence."/persist" = {
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
