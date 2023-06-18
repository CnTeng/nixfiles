{ config, lib, user, ... }:
with lib;
let cfg = config.desktop'.components.applet;
in {
  options.desktop'.components.applet.enable = mkEnableOption "applet component"
    // {
      default = config.desktop'.hyprland.enable;
    };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      xsession.preferStatusNotifierItems = true;

      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
      };
    };
  };
}
