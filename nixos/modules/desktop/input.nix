{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.input;
in
{
  options.desktop'.input.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb.options = "ctrl:nocaps";
    console.useXkbConfig = true;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };

    i18n.inputMethod.fcitx5 = {
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
      ];
      plasma6Support = true;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/fcitx"
        ".config/fcitx5"
        ".local/share/fcitx5"
      ];
    };
  };
}
