{ palette }:
{ lib, pkgs, ... }:
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
          "wlr/taskbar"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "memory"
          "backlight"
          "pulseaudio"
          "battery"
        ];

        "niri/workspaces" = { };
        "wlr/taskbar" = {
          icon-size = 15;
          on-click = "activate";
          on-click-middle = "close";
        };
        tray = {
          icon-size = 15;
          spacing = 10;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        memory = {
          format = " {percentage}%";
          on-click = lib.getExe pkgs.resources;
        };

        backlight = {
          format = "{icon}{percent}%";
          format-icons = " ";
          on-scroll-up = "${lib.getExe pkgs.brightnessctl} set +1%";
          on-scroll-down = "${lib.getExe pkgs.brightnessctl} set 1%-";
        };

        pulseaudio = {
          format = "{icon}{volume}%";
          format-bluetooth = " {volume}%";
          format-muted = " -%";
          format-source = " {volume}%";
          format-source-muted = " ";
          format-icons = {
            default = [
              " "
              " "
              " "
            ];
            headphone = " ";
            headset = " ";
            hands-free = " ";
          };
          on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = lib.getExe pkgs.pwvucontrol;
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
          format = "{:%a %b %d %R}";
          calendar.format = {
            months = "<span color='${palette.error_color}'>{}</span>";
            days = "<span color='${palette.accent_fg_color}'>{}</span>";
            weeks = "<span color='${palette.success_color}'>W{}</span>";
            weekdays = "<span color='${palette.warning_color}'>{}</span>";
            today = "<span color='${palette.accent_color}'><u>{}</u></span>";
          };
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
          tooltip-format = "{calendar}";
        };
      }
    ];
    style = ''
      * {
        font-family: Adwaita Mono, Noto Sans Mono CJK SC, FiraCode Nerd Font;
        font-weight: bold;
        font-size: 14px;
      }

      window#waybar {
        background: alpha(@theme_base_color, 0.9);
        color: @theme_text_color;
      }

      #workspaces,
      #taskbar button,
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
        color: ${palette.accent_color};
      }

      #battery.warning {
        color: ${palette.warning_color};
      }
      #battery.critical {
        color: ${palette.error_color};
      }
      #battery.charging {
        color: ${palette.success_color};
      }
    '';
  };
}
