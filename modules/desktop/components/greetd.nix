{ config, lib, pkgs, ... }:
with lib;
let cfg = config.desktop'.components.greetd;
in {
  options.desktop'.components.greetd.enable = mkEnableOption "greetd";

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
