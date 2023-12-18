{ config, lib, pkgs, themes, user, ... }:
with lib;
let
  cfg = config.desktop'.profiles.inputMethod;

  inherit (config.core'.colors) flavour;
  inherit (themes) fcitx5Theme;
in {
  options.desktop'.profiles.inputMethod.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.xserver.xkb.options = "ctrl:nocaps";

    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5 = {
      addons = with pkgs; [ fcitx5-chinese-addons fcitx5-pinyin-zhwiki ];
      settings = {
        globalOptions = {
          "Hotkey/PrevPage"."1" = "comma";
          "Hotkey/NextPage"."1" = "period";
        };
        inputMethod = {
          "Groups/0".DefaultIM = "pinyin";
          "Groups/0/Items/1".Name = "pinyin";
        };
        addons = {
          classicui.globalSection = {
            Font = ''"Sarasa UI SC 11"'';
            MenuFont = ''"Sarasa UI SC 11"'';
            TrayFont = ''"Sarasa UI SC 11"'';
            Theme = "catppuccin-${toLower flavour}";
            PerScreenDPI = "True";
            EnableFractionalScale = "False";
          };
          pinyin.globalSection = {
            CloudPinyinEnabled = "True";
            PinyinInPreedit = "True";
          };
        };
      };
    };

    environment.variables.GTK_IM_MODULE = lib.mkForce "wayland";

    home-manager.users.${user} = {
      i18n.inputMethod.enabled = "fcitx5";
      i18n.inputMethod.fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
      ];

      xdg.dataFile."fcitx5/themes".source = fcitx5Theme + /src;
    };
  };
}
