{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.waybar;

  inherit (config.home-manager.users.${user}.home) profileDirectory;
  inherit (config.basics') colorScheme;
  inherit (import ./lib.nix lib) hexToRgb;

  systemMonitor = "${lib.getExe pkgs.kitty} -e btop";
  networkManager = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
in {
  options.desktop'.components.waybar.enable =
    mkEnableOption "waybar" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.playerctld.enable = true;

      systemd.user.services.waybar = {
        Service.Environment = "PATH=${profileDirectory}/bin";
      };

      programs.waybar = with colorScheme; {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            output = ["eDP-1" "DP-3"];
            position = "top";
            height = 40;
            modules-left = [
              "wlr/workspaces"
              "hyprland/submap"
              "hyprland/window"
            ];

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

            "wlr/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = " ";
                "2" = " ";
                "3" = " ";
                "4" = " ";
                "5" = " ";
                "6" = " ";
                default = " ";
                urgent = " ";
              };
              sort-by-number = true;
              persistent_workspaces = {
                "1" = ["eDP-1"];
                "2" = ["DP-3"];
                "3" = ["eDP-1"];
                "4" = ["eDP-1"];
                "5" = ["eDP-1"];
                "6" = ["eDP-1"];
              };
              on-click = "activate";
            };

            "hyprland/submap" = {format = " {}";};

            tray = {
              icon-size = 22;
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
                chromium = " ";
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
              light = lib.getExe pkgs.light;
            in {
              format = "{icon}{percent}%";
              format-icons = " ";
              on-scroll-up = "${light} -A 5";
              on-scroll-down = "${light} -U 5";
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
                  months = "<span color='#${peach}'><b>{}</b></span>";
                  days = "<span color='#${text}'><b>{}</b></span>";
                  weeks = "<span color='#${blue}'><b>W{}</b></span>";
                  weekdays = "<span color='#${yellow}'><b>{}</b></span>";
                  today = "<span color='#${red}'><b><u>{}</u></b></span>";
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
            font-size: 17px;
          }

          window#waybar {
            color: #${text};
            background-color: rgba(${hexToRgb base}, 0.9);
            opacity: 0.9;
            padding: 0;
          }

          #workspaces {
            color: #${text};
            background-color: rgba(${hexToRgb surface1}, 0.9);
            padding: 0 5px;
            margin: 5px 3px 5px 0;
            border-radius: 0 15px 15px 0;
          }
          #workspaces button {
            color: #${text};
            padding: 0 0 0 3px;
            margin: 0 5px;
          }
          #workspaces button.focused,
          #workspaces button.active {
            color: #${blue};
          }
          #workspaces button.urgent {
            color: #${red};
          }

          #submap {
            color: #${base};
            background-color: rgba(${hexToRgb red}, 0.9);
            padding: 0 10px;
            margin: 5px 3px;
            border-radius: 15px;
          }

          #window,
          #tray {
            color: #${text};
            padding: 0 5px;
            margin: 5px 3px;
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
            color: #${text};
            background-color: rgba(${hexToRgb surface1}, 0.9);
            padding: 0 5px;
            margin: 5px 0;
          }

          #mpris,
          #idle_inhibitor,
          #cpu,
          #clock {
            padding-left: 10px;
            margin-left: 3px;
            border-top-left-radius: 15px;
            border-bottom-left-radius: 15px;
          }

          #mpris,
          #backlight,
          #battery {
            padding-right: 10px;
            margin-right: 3px;
            border-top-right-radius: 15px;
            border-bottom-right-radius: 15px;
          }

          #battery.warning {
            color: #${yellow};
          }
          #battery.critical {
            color: #${red};
          }
          #battery.charging {
            color: #${green};
          }
        '';
      };
    };
  };
}
