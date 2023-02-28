{ config, lib, user, ... }:

with lib;

let cfg = config.custom.desktop.components.applet;
in {
  options.custom.desktop.components.applet = {
    enable = mkEnableOption "applet";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user}.services = {
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    };
  };
}
