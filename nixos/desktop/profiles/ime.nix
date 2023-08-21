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

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-pinyin-zhwiki
        ];
        settings = {
          addons = {
            classicui.globalSection.Theme = "catppuccin-mocha";
          };
        };
        # ignoreUserConfig = true;
      };
    };
    home-manager.users.${user} = {
      systemd.user.services.fcitx5-daemon = {
        Unit = {
          Description = "Fcitx5 input method editor";
          PartOf = ["graphical-session.target"];
        };
        Service.ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}
