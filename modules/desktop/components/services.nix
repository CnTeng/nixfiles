{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.services;
in {
  options.desktop'.components.services.enable =
    mkEnableOption "Services" // {default = true;};

  config = mkIf cfg.enable {
    services = {
      gvfs.enable = true; # Enable trash

      # Enable USB Automounting
      udisks2.enable = true;
      devmon.enable = true;

      gnome = {
        # Fix warning 'The name org.a11y.Bus was not provided by any .service files'
        at-spi2-core.enable = true;
        gnome-keyring.enable = true;
      };

      upower.enable = true;
    };

    home-manager.users.${user} = {
      services.udiskie.enable = true;

      systemd.user.services.yubikey-touch-detector = {
        Unit = {
          Description = "Detects when your YubiKey is waiting for a touch";
          PartOf = ["graphical-session.target"];
        };

        Service.ExecStart = "${getExe pkgs.yubikey-touch-detector} --libnotify";

        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}
