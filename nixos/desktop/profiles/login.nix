{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.loginManager;
in {
  options.desktop'.profiles.loginManager.enable =
    mkEnableOption "login manager component";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command =
          "${getExe pkgs.greetd.tuigreet} "
          + "--time "
          + "--user-menu "
          + "--asterisks "
          + "--window-padding 1 "
          + "--cmd Hyprland";
        user = "greeter";
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
