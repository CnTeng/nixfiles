{ config, lib, user, ... }:
with lib;
let cfg = config.desktop'.components.applet;
in {
  options.desktop'.components.applet.enable = mkEnableOption "applet";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      xsession.preferStatusNotifierItems = true;

      services = {
        network-manager-applet.enable = true;
        blueman-applet.enable = true;
      };
    };
  };
}
