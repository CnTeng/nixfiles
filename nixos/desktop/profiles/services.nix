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

      xsession.preferStatusNotifierItems = true;

      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
      };

      systemd.user = {
        sockets.yubikey-touch-detector = {
          Unit.Description = "Unix socket activation for YubiKey touch detector service";
          Socket = {
            ListenStream = "%t/yubikey-touch-detector.socket";
            RemoveOnStop = true;
          };
          Install.WantedBy = ["sockets.target"];
        };

        services.yubikey-touch-detector = {
          Unit = {
            Description = "Detects when your YubiKey is waiting for a touch";
            Requires = "yubikey-touch-detector.socket";
          };
          Service = {
            ExecStart = "${lib.getExe pkgs.yubikey-touch-detector} --libnotify";
            EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
          };
          Install = {
            Also = "yubikey-touch-detector.socket";
            WantedBy = ["default.target"];
          };
        };
      };
    };
  };
}
