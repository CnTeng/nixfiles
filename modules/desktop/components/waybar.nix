{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.waybar;
  inherit (config.basics') colorScheme;

  btop = "${pkgs.kitty}/bin/kitty -e btop";
  mute = "${pkgs.pamixer}/bin/pamixer -t";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  networkmanager = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
  light = lib.getExe pkgs.light;
  inherit (import ./lib.nix lib) hexToRgb;
in {
  options.desktop'.components.waybar.enable = mkEnableOption "waybar";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.playerctld.enable = true;
      programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        systemd.enable = true;

        style = ''
          * {
            font-family: RobotoMono Nerd Font, Sarasa Gothic SC;
            font-weight: bold;
            font-size: 17px;
          }

          window#waybar {
            color: #${colorScheme.text};
            opacity: 0.9;
            background-color: rgba(${hexToRgb colorScheme.base}, 0.9);
            padding: 0;
          }

          #workspaces {
            color: #${colorScheme.text};
            background-color: rgba(${hexToRgb colorScheme.surface1}, 0.9);
            margin: 5px 5px 5px 0;
            padding: 0 5px;
            border-radius: 0 15px 15px 0;
          }
          #workspaces button {
            color: #${colorScheme.text};
            padding: 0 0 0 3px;
            margin: 0 5px;
          }
          #workspaces button.focused,
          #workspaces button.active {
            color: #${colorScheme.blue};
          }
          #workspaces button.urgent {
            color: #${colorScheme.red};
          }

          #submap {
            color: #${colorScheme.base};
            background-color: rgba(${hexToRgb colorScheme.red}, 0.9);
            margin: 5px;
            padding: 0 10px;
            border-radius: 15px;
          }

          #window,
          #tray {
            color: #${colorScheme.text};
            margin: 5px;
            padding: 0 5px;
          }


          #mpris {
            color: #${colorScheme.text};
            background-color: rgba(${hexToRgb colorScheme.surface1}, 0.9);
            margin: 5px;
            padding: 0 10px;
            border-radius: 15px;
          }

          #idle_inhibitor,
          #backlight {
            color: #${colorScheme.text};
            background-color: rgba(${hexToRgb colorScheme.surface1}, 0.9);
            margin: 5px;
            padding: 0 10px;
          }

          #idle_inhibitor {
            border-radius: 15px 0 0 15px;
            margin-right: 0;
            padding-right: 0;
          }

          #backlight {
            border-radius: 0 15px 15px 0;
            margin-left: 0;
            padding-left: 0;
          }

          #cpu,
          #memory,
          #pulseaudio,
          #network,
          #backlight,
          #battery,
          #clock {
            color: #${colorScheme.text};
            background-color: rgba(${hexToRgb colorScheme.surface1}, 0.9);
            margin: 5px 0;
          }

          #cpu {
            padding-left: 10px;
            margin-left: 5px;
            border-radius: 15px 0 0 15px;
          }

          #clock {
            padding-right: 10px;
          }

          #battery.warning {
            color: #${colorScheme.yellow};
          }
          #battery.critical {
            color: #${colorScheme.red};
          }
          #battery.charging {
            color: #${colorScheme.green};
          }
        '';
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
                default = " ";
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
              spacing = 15;
            };

            mpris = {
              format = "{player_icon} {status_icon} {title} {artist}";
              tooltip-format = ''
                {title}
                {artist}  {album}
                [{position}|{length}]'';
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
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "  ";
                deactivated = "  ";
              };
            };

            backlight = {
              format = "{icon}{percent}%";
              format-icons = " ";
              on-scroll-up = "${light} -A 5";
              on-scroll-down = "${light} -U 5";
            };

            cpu = {
              format = " {usage}% ";
              on-click = "${btop}";
            };

            memory = {
              format = " {percentage}% ";
              on-click = "${btop}";
            };

            pulseaudio = {
              format = "{icon}{volume}% ";
              format-bluetooth = "󰂰 {volume}% ";
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
              on-click = "${mute}";
              on-click-right = "${pavucontrol}";
              tooltip-format = "{icon}{desc} {volume}% ";
            };

            network = {
              format-wifi = "{icon}{essid} ";
              format-ethernet = " {ipaddr} ";
              format-linked = " No IP ";
              format-disconnected = "  ";
              format-icons = {
                wifi = ["󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 "];
              };
              max-length = 10;
              tooltip-format = ''
                {ifname} {ipaddr}/{cidr}
                Up: {bandwidthUpBits}
                Down: {bandwidthDownBits}'';
              tooltip-format-wifi = ''
                {essid} {signalStrength}%
                Up: {bandwidthUpBits}
                Down: {bandwidthDownBits}'';
              on-click-right = "${networkmanager}";
            };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}{capacity}% ";
              format-charging = " {capacity}% ";
              format-icons = [" " " " " " " " " "];
            };

            clock = {
              format = "{: %b %d  %H:%M}";
              tooltip-format = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
              format-alt = "{:%A %B %d %Y}";
            };
          }
        ];
      };

      systemd.user.services.waybar = {
        Service = {
          Environment = [
            "PATH=${
              config.home-manager.users.${user}.home.profileDirectory
            }/bin"
          ];
        };
      };
    };
  };
}
