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
      settings = {
        default_session = {
          command = "${getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}
