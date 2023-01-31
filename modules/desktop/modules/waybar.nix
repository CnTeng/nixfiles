{ pkgs, user, ... }:

let
  colorScheme = import ./colorscheme.nix;

  btop = "${pkgs.kitty}/bin/kitty -e btop";
  mute = "${pkgs.pamixer}/bin/pamixer -t";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  networkmanager = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
in
{
  home-manager.users.${user} = {
    # Maybe necessary for tray
    home.packages = with pkgs;
      [
        libappindicator
        # TODO:add mpris and set max-length
        # playerctl
      ];

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      style = ''
        * {
          font-family: RobotoMono Nerd Font, Sarasa Gothic SC;
          font-weight: bold;
          font-size: 17px;
        }

        window#waybar {
          color: #${colorScheme.text};
          opacity: 0.9;
          background-color: #${colorScheme.base};
          padding: 0;
          border-radius: 10px;
        }

        #custom-nixos {
          color: #${colorScheme.text};
          background-color: #${colorScheme.base};
          border-radius: 10px;
          padding-left: 15px;
          padding-right: 20px;
        }

        #custom-separator {
          color: #${colorScheme.text};
          margin: 0 6px;
        }

        #workspaces {
          color: #${colorScheme.text};
          background-color: #${colorScheme.base};
          border-radius: 0;
        }
        #workspaces button {
          color: #${colorScheme.text};
          padding: 0 15px;
          border-radius: 0;
        }
        #workspaces button.hidden {
          color: #${colorScheme.text};
          background-color: #${colorScheme.base};
        }
        #workspaces button.focused,
        #workspaces button.active {
          color: #${colorScheme.text};
          background-color: #${colorScheme.surface0};
          border-bottom: 4px solid #${colorScheme.blue};
          padding: 8px 15px 4px;
        }
        #workspaces button.urgent {
          color: #${colorScheme.text};
          background-color: #${colorScheme.red};
          border-bottom: 4px solid #${colorScheme.blue};
          padding: 8px 15px 4px;
        }

        #window {
          color: #${colorScheme.text};
        }

        #submap {
          color: #${colorScheme.text};
          margin-left: 6px;
        }

        #tray,
        #mpris,
        #idle_inhibitor,
        #cpu,
        #memory,
        #pulseaudio,
        #network,
        #battery {
          color: #${colorScheme.text};
        }

        #clock {
          color: #${colorScheme.text};
          margin-right: 15px;
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
      settings = [{
        layer = "top";
        output = [
          "eDP-1"
          "DP-3"
        ];
        position = "top";
        height = 40;
        margin = "5px 5px 0";
        modules-left = [
          "custom/nixos"
          "wlr/workspaces"
          "custom/separator"
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "hyprland/submap"
          "custom/separator"
          "idle_inhibitor"
          "custom/separator"
          "cpu"
          "custom/separator"
          "memory"
          "custom/separator"
          "pulseaudio"
          "custom/separator"
          "network"
          "custom/separator"
          "battery"
          "custom/separator"
          "clock"
        ];

        "custom/nixos" = {
          format = "";
        };

        "custom/separator" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };

        "wlr/workspaces" = {
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
        };

        tray = {
          icon-size = 22;
          spacing = 15;
        };

        "hyprland/submap" = {
          format = "<span color='#${colorScheme.blue}'>SMAP</span> {}";
        };

        idle_inhibitor = {
          format = "<span color='#${colorScheme.blue}'>IDLE</span> {icon}";
          format-icons = {
            activated = "OFF";
            deactivated = "ON";
          };
        };

        cpu = {
          format = "<span color='#${colorScheme.blue}'>CPU</span> {usage}%";
          on-click = "${btop}";
        };

        memory = {
          format = "<span color='#${colorScheme.blue}'>RAM</span> {percentage}%";
          on-click = "${btop}";
        };

        pulseaudio = {
          format = "<span color='#${colorScheme.blue}'>VOL</span> {volume}%";
          format-muted = "<span color='#${colorScheme.blue}'>MUT</span>";
          format-bluetooth = "<span color='#${colorScheme.blue}'>BT</span> {volume}%";
          tooltip-format = "{desc} {volume}%";
          on-click = "${mute}";
          on-click-right = "${pavucontrol}";
        };

        network = {
          format-wifi = "<span color='#${colorScheme.blue}'>WLAN</span> {essid}";
          format-ethernet = "<span color='#${colorScheme.blue}'>{ifname}</span> {ipaddr}/{cidr}";
          format-linked = "<span color='#${colorScheme.blue}'>{ifname}</span> No IP";
          format-disconnected = "Not connected";
          format-alt = "<span color='#${colorScheme.blue}'>{ifname}</span> {ipaddr}/{cidr}";
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
          format = "<span color='#${colorScheme.blue}'>BAT</span> {capacity}%";
          format-charging = "<span color='#${colorScheme.blue}'>CHG</span> {capacity}%";
          max-length = 25;
        };

        clock = {
          format = "{:<span color='#${colorScheme.blue}'>%b %d</span> %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:<span color='#${colorScheme.blue}'>%A %B</span> %d %Y}";
        };
      }];
    };
  };
}
