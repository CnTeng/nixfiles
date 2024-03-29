{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.login;
in
{
  options.desktop'.profiles.login.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command =
          getExe pkgs.greetd.tuigreet
          + " --time"
          + " --user-menu"
          + " --asterisks"
          + " --window-padding 1"
          + " --cmd sway";
        user = "greeter";
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
