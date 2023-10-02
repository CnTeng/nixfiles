{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.services;
in {
  options.desktop'.profiles.services.enable =
    mkEnableOption "services component";

  config = mkIf cfg.enable {
    services = {
      gnome = {
        # Fix warning 'The name org.a11y.Bus was not provided by any .service files'
        at-spi2-core.enable = true;
        gnome-keyring.enable = true;
      };

      upower.enable = true;

      dbus.implementation = "broker";
    };

    home-manager.users.${user} = {
      home.packages = [pkgs.wl-clipboard];

      services.clipman.enable = true;
    };
  };
}
