{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.wireless;
in {
  options.desktop'.profiles.wireless.enable = mkEnableOption "wireless support";

  config = mkIf cfg.enable {
    # network
    users.users.${user}.extraGroups = ["networkmanager"];

    networking.networkmanager.enable = true;

    environment.persistence."/persist".directories =
      mkIf config.hardware'.stateless.enable
      ["/etc/NetworkManager/system-connections"];

    # bluetooth
    hardware.bluetooth.enable = true;

    services.blueman.enable = true;

    home-manager.users.${user} = {
      # network
      xsession.preferStatusNotifierItems = true;
      services.network-manager-applet.enable = true;

      # bluetooth
      services.blueman-applet.enable = true;
    };
  };
}
