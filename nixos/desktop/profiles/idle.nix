{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.profiles.idle;

  inherit (config.basics'.colors) palette;
in {
  options.desktop'.profiles.idle.enable =
    mkEnableOption "idle daemon component";

  config = mkIf cfg.enable {
    security.pam.services.swaylock = { };

    home-manager.users.${user} = {
      programs.swaylock = with palette;
        let
          mkBaseColor = n: {
            "${n}-color" = base.hex + "e6";
            "${n}-clear-color" = base.hex + "e6";
            "${n}-ver-color" = base.hex + "e6";
            "${n}-wrong-color" = base.hex + "e6";
          };
        in {
          enable = true;
          package = pkgs.swaylock-effects;
          settings = {
            # Options
            ignore-empty-password = true;
            daemonize = true;

            # Appearance
            indicator = true;
            clock = true;
            image = toString config.desktop'.profiles.wallpaper.image;

            font = "RobotoMono Nerd Font";
            font-size = 50;
            indicator-radius = 120;

            key-hl-color = blue.hex;
            bs-hl-color = red.hex;
            separator-color = base.hex + "e6";

            text-color = text.hex;
            text-clear-color = teal.hex;
            text-ver-color = green.hex;
            text-wrong-color = red.hex;
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
        events = [{
          event = "lock";
          command = (getExe pkgs.playerctl + " pause; ")
            + getExe pkgs.swaylock-effects;
        }];
      };
    };
  };
}
