{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.components.inputMethod;
  inherit (config.home-manager.users.${user}.home) profileDirectory;
in {
  options.desktop'.components.inputMethod.enable =
    mkEnableOption "input method component" // {
      default = config.desktop'.hyprland.enable;
    };

  config = mkIf cfg.enable {
    services.xserver = {
      layout = "us";
      xkbOptions = "caps:swapescape";
      libinput.enable = true;
    };

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
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
          Environment = [
            # "QT_QPA_PLATFORMTHEME=gtk2"
            # "GTK2_RC_FILES=${
            #   config.home-manager.users.${user}.gtk.gtk2.configLocation
            # }"
            "PATH=${profileDirectory}/bin"
          ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
