{
  config,
  lib,
  pkgs,
  user,
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
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/fcitx"
        ".config/fcitx5"
      ];
    };
  };
}
