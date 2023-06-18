{ config, lib, pkgs, ... }:
with lib;
let cfg = config.desktop'.components.loginManager;
in {
  options.desktop'.components.loginManager.enable =
    mkEnableOption "login manager component" // {
      default = config.desktop'.hyprland.enable;
    };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}
