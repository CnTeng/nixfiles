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

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    home-manager.users.${user} = {
      home.packages = [pkgs.wl-clipboard];

      services.clipman.enable = true;

      xsession.preferStatusNotifierItems = true;

      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
      };

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
