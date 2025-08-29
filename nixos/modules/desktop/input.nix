{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.input;
in
{
  options.desktop'.input.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };

    i18n.inputMethod.fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
    ];

    preservation'.user.directories = [
      ".config/fcitx"
      ".config/fcitx5"
      ".local/share/fcitx5"
    ];
  };
}
