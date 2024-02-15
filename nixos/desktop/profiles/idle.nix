{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.idle;

  inherit (config.core'.colors) palette;
in
{
  options.desktop'.profiles.idle.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    security.pam.services.gtklock = { };

    home-manager.users.${user} = {
      programs.swaylock =
        with palette;
        let
          mkBaseColor = n: {
            "${n}-color" = dark_1 + "e6";
            "${n}-clear-color" = dark_1 + "e6";
            "${n}-ver-color" = dark_1 + "e6";
            "${n}-wrong-color" = dark_1 + "e6";
          };
        in
        {
          enable = true;
          package = pkgs.swaylock-effects;
          settings = {
            # Options
            daemonize = true;

            # Appearance
            indicator = true;
            clock = true;
            screenshots = true;

            font = "RobotoMono Nerd Font";
            font-size = 50;
            indicator-radius = 120;

            key-hl-color = blue_1;
            bs-hl-color = red_1;
            separator-color = dark_1 + "e6";

            text-color = light_1;
            text-clear-color = blue_1;
            text-ver-color = green_1;
            text-wrong-color = red_1;
          } // mkBaseColor "inside" // mkBaseColor "line" // mkBaseColor "ring";
        };

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 240;
            command = (getExe' pkgs.systemd "loginctl") + " lock-session";
          }
          {
            timeout = 300;
            command = (getExe' pkgs.systemd "systemctl") + " suspend";
          }
        ];
        events = [
          {
            event = "lock";
            command = getExe pkgs.playerctl + " pause";
          }
          {
            event = "lock";
            command = getExe pkgs.gtklock + " -d -S";
          }
        ];
      };
    };
  };
}
