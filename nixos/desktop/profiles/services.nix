{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.services;
in
{
  options.desktop'.profiles.services.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.upower.enable = true;
    services.dbus.implementation = "broker";
    services.gvfs.enable = true;

    # power
    services.tlp.enable = true;
    services.thermald.enable = true;

    home-manager.users.${user} = {
      home.packages = [ pkgs.wl-clipboard ];

      services.udiskie.enable = true;
      services.clipman.enable = true;

      services.playerctld.enable = true;
      services.swayosd.enable = true;
    };
  };
}
