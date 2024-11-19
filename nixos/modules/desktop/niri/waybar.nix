{
  lib,
  pkgs,
  ...
}:
let
  palette = import ./palette.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "niri/workspaces"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "mpris"
          "idle_inhibitor"
          "backlight"
          "memory"
          "pulseaudio"
          "battery"
        ];

        "niri/workspaces" = { };
        tray = {
          icon-size = 15;
          spacing = 10;
        };
        mpris = {
          format = "{player_icon} {status_icon}{title}";
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

        backlight = {
          format = "{icon}{percent}%";
          format-icons = " ";
          on-scroll-up = "${lib.getExe pkgs.brillo} -u 300000 -A 5";
          on-scroll-down = "${lib.getExe pkgs.brillo} -u 300000 -U 5";
        };

        memory = {
          format = " {percentage}%";
          on-click = "${lib.getExe pkgs.kitty} -e btop";
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
          on-click-right = lib.getExe pkgs.pavucontrol;
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
              months = "<span color='${palette.red_1}'><b>{}</b></span>";
              days = "<span color='${palette.light_1}'><b>{}</b></span>";
              weeks = "<span color='${palette.blue_1}'><b>W{}</b></span>";
              weekdays = "<span color='${palette.yellow_1}'><b>{}</b></span>";
              today = "<span color='${palette.red_1}'><b><u>{}</u></b></span>";
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
        font-family: Noto Sans Mono, Noto Sans Mono CJK SC, FiraCode Nerd Font;
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
      #workspaces button.focused,
      #workspaces button.active {
        color: ${palette.blue_1};
      }
      #battery.warning {
        color: @warning_color;
      }
      #battery.critical {
        color: @error_color;
      }
      #battery.charging {
        color: @success_color;
      }
    '';
  };
}
