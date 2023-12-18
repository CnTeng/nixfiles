{ config, lib, user, ... }:
with lib;
let cfg = config.desktop'.profiles.wireless;
in {
  options.desktop'.profiles.wireless.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    # network
    users.users.${user}.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;
    environment.persistence."/persist".directories =
      mkIf config.hardware'.persist.enable
      [ "/etc/NetworkManager/system-connections" ];

    # bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    home-manager.users.${user} = { services.blueman-applet.enable = true; };
  };
}
