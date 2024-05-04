{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.profiles.waybar;

  inherit (config.desktop'.profiles) palette;

  systemMonitor = "${lib.getExe pkgs.kitty} -e btop";
in
{
  options.desktop'.profiles.waybar.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.waybar = with palette; {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            output = [
              "eDP-1"
              "DP-2"
              "DP-3"
            ];
            position = "top";
            modules-left = [
              "sway/workspaces"
              "sway/mode"
            ];

            modules-center = [ "clock" ];

            modules-right = [
              "tray"
              "mpris"
              "idle_inhibitor"
              "backlight"
              "cpu"
              "memory"
              "pulseaudio"
              "battery"
            ];

            "sway/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = " ";
                "2" = " ";
                "3" = " ";
                "4" = " ";
                "5" = " ";
                "6" = " ";
                default = " ";
                special = " ";
                urgent = " ";
              };
              show-special = true;
            };

            "sway/mode".format = " {}";

            tray = {
              icon-size = 15;
              spacing = 10;
            };

            mpris = {
              format = "{player_icon} {status_icon}{title} {artist}";
              artist-len = 10;
              album-len = 10;
              title-len = 10;
              player-icons = {
                firefox = " ";
                spotify = " ";
                chromium = " ";
              };
              status-icons = {
                playing = " ";
                paused = " ";
                stopped = " ";
              };
              tooltip-format = ''
                {title}
                {artist}  {album}
                {position} {length}'';
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = " ";
                deactivated = " ";
              };
            };

            backlight =
              let
                brillo = lib.getExe pkgs.brillo;
              in
              {
                format = "{icon}{percent}%";
                format-icons = " ";
                on-scroll-up = "${brillo} -u 300000 -A 5";
                on-scroll-down = "${brillo} -u 300000 -U 5";
              };

            cpu = {
              format = " {usage}%";
              on-click = "${systemMonitor}";
            };

            memory = {
              format = " {percentage}%";
              on-click = "${systemMonitor}";
            };

            pulseaudio = {
              format = "{icon}{volume}%";
              format-bluetooth = "󰂰 {volume}%";
              format-muted = " ";
              format-source = " {volume}%";
              format-source-muted = " ";
              format-icons = {
                default = [
                  " "
                  " "
                  " "
                ];
                headphone = "󰋋 ";
                hdmi = " ";
                headset = "󰋎 ";
                hands-free = "󰋎 ";
                portable = " ";
                phone = " ";
                car = " ";
              };
              on-click = "${lib.getExe pkgs.pamixer} -t";
              on-click-right = "${lib.getExe pkgs.pavucontrol}";
              tooltip-format = "{icon}{desc} {volume}%";
            };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}{capacity}%";
              format-charging = " {capacity}%";
              format-icons = [
                " "
                " "
                " "
                " "
                " "
              ];
              tooltip-format = ''
                {power}W
                {timeTo}'';
            };

            clock = {
              format = " {:%b %d %R}";
              format-alt = " {:%A %B %d %Y}";
              tooltip-format = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
              calendar = {
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months = "<span color='${red_1}'><b>{}</b></span>";
                  days = "<span color='${light_1}'><b>{}</b></span>";
                  weeks = "<span color='${blue_1}'><b>W{}</b></span>";
                  weekdays = "<span color='${yellow_1}'><b>{}</b></span>";
                  today = "<span color='${red_1}'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };
          }
        ];

        style = ''
          * {
            font-family: RobotoMono Nerd Font, Sarasa UI SC;
            font-weight: bold;
            font-size: 14px;
          }

          #workspaces,
          #mode,
          #clock,
          #tray,
          #mpris,
          #idle_inhibitor,
          #backlight,
          #cpu,
          #memory,
          #pulseaudio,
          #battery {
            padding: 0 6px;
          }

          #workspaces button {
            padding: 3px 6px;
          }
          #workspaces button.focused {
            color: ${blue_1};
          }
          #workspaces button.urgent {
            color: ${red_1};
          }

          #battery.warning {
            color: ${yellow_1};
          }
          #battery.critical {
            color: ${red_1};
          }
          #battery.charging {
            color: ${green_1};
          }
        '';
      };
    };
  };
}
