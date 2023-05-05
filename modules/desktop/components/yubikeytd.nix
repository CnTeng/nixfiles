{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.yubikeytd;
in {
  options.desktop'.components.yubikeytd.enable =
    mkEnableOption "yubikey-touch-detector";

  config = mkIf cfg.enable {
    home-manager.users.${user}.systemd.user = {
      services.yubikey-touch-detector = {
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
