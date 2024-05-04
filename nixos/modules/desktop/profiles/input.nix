{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.profiles.inputMethod;
in
{
  options.desktop'.profiles.inputMethod.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;

    environment.pathsToLink = [ "/share/fcitx5" ];

    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5 = {
      plasma6Support = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
      ];
      settings = {
        globalOptions = {
          "Hotkey/PrevPage"."1" = "comma";
          "Hotkey/NextPage"."1" = "period";
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
          GroupOrder."0" = "Default";
        };
        addons = {
          classicui.globalSection = {
            Font = ''"Sarasa UI SC 11"'';
            MenuFont = ''"Sarasa UI SC 11"'';
            TrayFont = ''"Sarasa UI SC 11"'';
            UseDarkTheme = "True";
            EnableFractionalScale = "False";
          };
          pinyin.globalSection = {
            CloudPinyinEnabled = "True";
            PinyinInPreedit = "True";
          };
        };
      };
      ignoreUserConfig = true;
    };

    systemd.user.services.fcitx5-daemon = {
      description = "Fcitx5 input method editor";
      environment.SKIP_FCITX_USER_PATH = "1";
      script = lib.getExe' config.i18n.inputMethod.package "fcitx5";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
