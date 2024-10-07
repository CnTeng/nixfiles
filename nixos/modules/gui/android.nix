{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.android;
in
{
  options.gui'.android.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "adbusers" ];

    programs.adb.enable = true;

    home-manager.users.${user} =
      { config, ... }:
      {
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

        home.sessionVariables = {
          _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
          ADB_VENDOR_KEY = "${config.xdg.configHome}/android";
          ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
          ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
        };
      };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".cache/Google"
        ".config/Google"
        ".local/share/Google"

        ".config/java"
        ".gradle"

        ".config/android"
        ".local/share/android"
      ];
    };
  };
}
