{ pkgs, user, ... }:

let
  # Catppuccin Macchiato
  # Copy from https://github.com/catppuccin/catppuccin
  base00 = "24273a"; # base
  base01 = "1e2030"; # mantle
  base02 = "363a4f"; # surface0
  base03 = "494d64"; # surface1
  base04 = "5b6078"; # surface2
  base05 = "cad3f5"; # text
  base06 = "f4dbd6"; # rosewater
  base07 = "b7bdf8"; # lavender
  base08 = "ed8796"; # red
  base09 = "f5a97f"; # peach
  base0A = "eed49f"; # yellow
  base0B = "a6da95"; # green
  base0C = "8bd5ca"; # teal
  base0D = "8aadf4"; # blue
  base0E = "c6a0f6"; # mauve
  base0F = "f0c6c6"; # flamingo

  btop = "${pkgs.kitty}/bin/kitty -e btop";
  mute = "${pkgs.pamixer}/bin/pamixer -t";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  networkmanager = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
in
{
  home-manager.users.${user} = {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      style = ''
        * {
          font-family: RobotoMono Nerd Font, Noto Sans Mono CJK SC;
          font-weight: bold;
          font-size: 17px;
        }

        window#waybar {
          color: #${base05};
          opacity: 0.95;
          background-color: #${base00};
          padding: 0;
          border-radius: 10px;
        }

        #workspaces button {
          color: #${base05};
          background-color: #${base00};
          padding: 0 15px;
          margin-right: 3px;
          border-radius: 10px;
        }
        #workspaces button.hidden {
          color: #${base05};
          background-color: #${base00};
        }
        #workspaces button.focused,
        #workspaces button.active {
          color: #${base00};
          background-color: #${base0D};
        }

        #window,
        #tray,
        #cpu,
        #memory,
        #pulseaudio,
        #network,
        #battery,
        #clock {
          color: #${base05};
          margin: 0 3px;
        }
        #battery.warning {
          color: #${base0A};
        }
        #battery.critical {
          color: #${base08};
        }
        #battery.charging {
          color: #${base0B};
        }
      '';
      settings = [{
        layer = "top";
        output = [
          "eDP-1"
          "DP-3"
        ];
        position = "top";
        height = 40;
        margin = "5px 5px 0";
        modules-left = [ "wlr/workspaces" "hyprland/window" ];
        modules-right = [ "tray" "cpu" "memory" "pulseaudio" "network" "battery" "clock" ];

        "wlr/workspaces" = {
          on-click = "activate"; # It can't work in hyprland
          all-outputs = true;
          # format = "{icon}";
          # format-icons = {
          #   "1" = "";
          #   "2" = "";
          #   "3" = "";
          #   "4" = "";
          #   "5" = "";
          #   "6" = "";
          #   "7" = "";
          #   "8" = "";
          # };
        };

        tray = {
          icon-size = 22;
          spacing = 15;
        };

        cpu = {
          format = "{usage}% {icon}";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          interval = 10;
          on-click = "${btop}";
        };

        memory = {
          format = "{percentage}% ";
          interval = 30;
          on-click = "${btop}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-bluetooth = "{volume}% ";
          format-icons = {
            default = [ "" "" "" ];
            headphone = "";
          };
          tooltip-format = "{desc} {volume}%";
          on-click = "${mute}";
          on-click-right = "${pavucontrol}";
        };

        network = {
          format-wifi = "{signalStrength}% 直";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}";
          format-linked = "直 {ifname} (No IP)";
          format-disconnected = " Not connected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{essid} {signalStrength}%";
          on-click-right = "${networkmanager}";
        };

        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
          max-length = 25;
        };

        clock = {
          format = "{:%b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %B %d, %Y}";
        };

      }];
    };
  };
}
