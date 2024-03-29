{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.wireless;
in
{
  options.desktop'.profiles.wireless.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;
    environment.persistence."/persist".directories = mkIf config.hardware'.persist.enable [
      "/etc/NetworkManager/system-connections"
    ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    home-manager.users.${user} = {
      services.network-manager-applet.enable = true;
      services.blueman-applet.enable = true;
    };
  };
}
