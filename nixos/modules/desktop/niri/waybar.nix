palette:
{ lib, pkgs, ... }:
let
  xmlFormat = pkgs.formats.xml { };
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
          "power-profiles-daemon"
        ];

        "wlr/taskbar" = {
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

          menu = "on-click-right";
          menu-file = xmlFormat.generate "powermenu.xml" {
            interface.object = {
              "@class" = "GtkMenu";
              "@id" = "menu";
              child =
                let
                  mkGtkMenuItem = id: name: {
                    object = {
                      "@class" = "GtkMenuItem";
                      "@id" = id;
                      property = {
                        "@name" = "label";
                        "#text" = name;
                      };
                    };
                  };
                in
                [
                  (mkGtkMenuItem "lock" "Lock")
                  (mkGtkMenuItem "logout" "Logout")
                  {
                    object = {
                      "@class" = "GtkSeparatorMenuItem";
                      "@id" = "delimiter";
                    };
                  }
                  (mkGtkMenuItem "suspend" "Suspend")
                  (mkGtkMenuItem "shutdown" "Shutdown")
                  (mkGtkMenuItem "reboot" "Reboot")
                ];
            };
          };
          menu-actions = {
            lock = "loginctl lock-session";
            logout = "niri msg action quit";
            suspend = "systemctl suspend";
            shutdown = "systemctl poweroff";
            reboot = "systemctl reboot";
          };
        };

        power-profiles-daemon = {
          format = "{icon}";
          format-icons = {
            default = " ";
            performance = " ";
            balanced = " ";
            power-saver = " ";
          };
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
    style = # css
      ''
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
        #mode,
        #clock,
        #tray,
        #mpris,
        #idle_inhibitor,
        #backlight,
        #cpu,
        #memory,
        #pulseaudio,
        #battery,
        #power-profiles-daemon {
          padding: 0 6px;
        }

        #taskbar button {
          border: none;
          border-radius: 0;
          box-shadow: inset 0 -3px transparent;
          padding: 3px 8px;
        }
        #taskbar button.active {
          box-shadow: inset 0 -3px ${palette.accent_color};
        }

        #workspaces button {
          border-radius: 0;
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

        #power-profiles-daemon.performance {
          color: ${palette.warning_color};
        }
        #power-profiles-daemon.power-saver {
          color: ${palette.success_color};
        }
      '';
  };
}
