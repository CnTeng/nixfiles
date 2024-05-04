{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.profiles.login;
in
{
  options.desktop'.profiles.login.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command =
          lib.getExe pkgs.greetd.tuigreet
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
