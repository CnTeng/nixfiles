{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.waybar;

  inherit (config.basics'.colors) palette;

  systemMonitor = "${lib.getExe pkgs.kitty} -e btop";
  networkManager = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
in {
  options.desktop'.profiles.waybar.enable =
    mkEnableOption "waybar";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.waybar = with palette; {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            output = ["eDP-1" "DP-2" "DP-3"];
            position = "top";
            height = 32;
            modules-left = ["hyprland/workspaces" "hyprland/submap" "hyprland/window"];

            modules-right = [
              "tray"
              "mpris"
              "idle_inhibitor"
              "backlight"
              "cpu"
              "memory"
              "pulseaudio"
              "network"
              "battery"
              "clock"
            ];

            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = " ";
                "2" = " ";
                "3" = " ";
                "4" = " ";
                "5" = " ";
                "6" = " ";
                default = " ";
                urgent = " ";
              };
              show-special = true;
            };

            "hyprland/submap" = {format = " {}";};

            "hyprland/window" = {
              separate-outputs = true;
            };

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

            backlight = let
              brillo = lib.getExe pkgs.brillo;
            in {
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
              format-muted = " ";
              format-source = " {volume}%";
              format-source-muted = " ";
              format-icons = {
                default = [" " " " " "];
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

            network = {
              format-wifi = "{icon}{essid}";
              format-ethernet = "{icon}{ipaddr}";
              format-linked = "{icon}No IP";
              format-disconnected = "{icon}";
              format-icons = {
                ethernet = " ";
                wifi = ["󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 "];
                linked = " ";
                disconnected = " ";
              };
              max-length = 10;
              tooltip-format = ''
                {icon}{ifname} {ipaddr}/{cidr}
                 {bandwidthUpBits}
                 {bandwidthDownBits}'';
              tooltip-format-wifi = ''
                {icon}{essid} {signalStrength}%
                 {bandwidthUpBits}
                 {bandwidthDownBits}'';
              on-click-right = "${networkManager}";
            };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}{capacity}%";
              format-charging = " {capacity}%";
              format-icons = [" " " " " " " " " "];
            };

            clock = {
              format = "{: %b %d  %H:%M}";
              format-alt = "{: %A %B %d %Y}";
              tooltip-format = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
              calendar = {
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months = "<span color='${peach.hex}'><b>{}</b></span>";
                  days = "<span color='${text.hex}'><b>{}</b></span>";
                  weeks = "<span color='${blue.hex}'><b>W{}</b></span>";
                  weekdays = "<span color='${yellow.hex}'><b>{}</b></span>";
                  today = "<span color='${red.hex}'><b><u>{}</u></b></span>";
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

          window#waybar {
            color: ${text.hex};
            background-color: rgba(${base.raw}, 0.9);
            opacity: 0.9;
            padding: 0;
          }

          #workspaces {
            color: ${text.hex};
            background-color: rgba(${surface1.raw}, 0.9);
            padding: 0 4px;
            margin: 4px 3px 4px 0;
            border-radius: 0 11px 11px 0;
          }
          #workspaces button {
            color: ${text.hex};
            padding: 0 0 0 3px;
            margin: 0 4px;
          }
          #workspaces button.focused,
          #workspaces button.active {
            color: ${blue.hex};
          }

          #submap {
            color: ${base.hex};
            background-color: rgba(${red.raw}, 0.9);
            padding: 0 8px;
            margin: 4px 3px;
            border-radius: 11px;
          }

          #window,
          #tray {
            color: ${text.hex};
            padding: 0 4px;
            margin: 4px 3px;
          }

          #mpris,
          #idle_inhibitor,
          #backlight,
          #cpu,
          #memory,
          #pulseaudio,
          #network,
          #battery,
          #clock {
            color: ${text.hex};
            background-color: rgba(${surface1.raw}, 0.9);
            padding: 0 4px;
            margin: 4px 0;
          }

          #mpris,
          #idle_inhibitor,
          #cpu,
          #clock {
            padding-left: 8px;
            margin-left: 3px;
            border-top-left-radius: 11px;
            border-bottom-left-radius: 11px;
          }

          #mpris,
          #backlight,
          #battery {
            padding-right: 8px;
            margin-right: 3px;
            border-top-right-radius: 11px;
            border-bottom-right-radius: 11px;
          }

          #battery.warning {
            color: ${yellow.hex};
          }
          #battery.critical {
            color: ${red.hex};
          }
          #battery.charging {
            color: ${green.hex};
          }
        '';
      };
    };
  };
}
