{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.inputMethod;
in {
  options.desktop'.profiles.inputMethod.enable =
    mkEnableOption "input method component";

  config = mkIf cfg.enable {
    services.xserver = {
      layout = "us";
      xkbOptions = "caps:swapescape";
      libinput.enable = true;
    };

    home-manager.users.${user} = {
      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-pinyin-zhwiki
          catppuccin-fcitx5
        ];
      };
    };
  };
}
