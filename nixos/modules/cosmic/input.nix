{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cosmic.profiles.input;
in
{
  options.cosmic.profiles.input.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };

    i18n.inputMethod.fcitx5 = {
      plasma6Support = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
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
            Font = ''"Noto Sans Mono CJK SC 11"'';
            MenuFont = ''"Noto Sans Mono CJK SC 11"'';
            TrayFont = ''"Noto Sans Mono CJK SC 11"'';
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
  };
}
