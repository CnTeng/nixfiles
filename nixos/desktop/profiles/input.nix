{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.inputMethod;

  inherit (config.core'.colors) flavour;
in
{
  options.desktop'.profiles.inputMethod.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.xserver.xkb.options = "ctrl:nocaps";
    environment.pathsToLink = [ "/share/fcitx5" ];

    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5 = {
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
        fcitx5-catppuccin
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
            Theme = "catppuccin-${toLower flavour}";
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
      script = getExe' config.i18n.inputMethod.package "fcitx5";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
