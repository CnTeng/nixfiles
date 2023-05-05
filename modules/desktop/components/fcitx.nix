{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.fcitx;
in {
  options.desktop'.components.fcitx.enable = mkEnableOption "fcitx";

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
        # catppuccin-fcitx5
      ];
    };
    home-manager.users.${user} = {
      systemd.user.services.fcitx5-daemon = {
        Unit = {
          Description = "Fcitx5 input method editor";
          PartOf = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
          Environment = [
            # "QT_QPA_PLATFORMTHEME=gtk2"
            # "GTK2_RC_FILES=${
            #   config.home-manager.users.${user}.gtk.gtk2.configLocation
            # }"
            "PATH=${
              config.home-manager.users.${user}.home.profileDirectory
            }/bin"
          ];
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}
