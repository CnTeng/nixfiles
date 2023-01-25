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
          color: #${colorScheme.base05};
          opacity: 0.9;
          background-color: #${colorScheme.base00};
          padding: 0;
          border-radius: 10px;
        }

        #custom-nixos {
          color: #${colorScheme.base05};
          background-color: #${colorScheme.base00};
          border-radius: 10px;
          padding-left: 15px;
          padding-right: 20px;
        }

        #custom-separator {
          color: #${colorScheme.base05};
          margin: 0 6px;
        }

        #workspaces {
          color: #${colorScheme.base05};
          background-color: #${colorScheme.base00};
          border-radius: 0;
        }
        #workspaces button {
          color: #${colorScheme.base05};
          padding: 0 15px;
          border-radius: 0;
        }
        #workspaces button.hidden {
          color: #${colorScheme.base05};
          background-color: #${colorScheme.base00};
        }
        #workspaces button.focused,
        #workspaces button.active {
          color: #${colorScheme.base05};
          background-color: #${colorScheme.base02};
          border-bottom: 4px solid #${colorScheme.base0D};
          padding: 8px 15px 4px;
        }
        #workspaces button.urgent {
          color: #${colorScheme.base05};
          background-color: #${colorScheme.base08};
          border-bottom: 4px solid #${colorScheme.base0D};
          padding: 8px 15px 4px;
        }

        #window {
          color: #${colorScheme.base05};
        }

        #submap {
          color: #${colorScheme.base05};
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
          color: #${colorScheme.base05};
        }

        #clock {
          color: #${colorScheme.base05};
          margin-right: 15px;
        }

        #battery.warning {
          color: #${colorScheme.base0A};
        }
        #battery.critical {
          color: #${colorScheme.base08};
        }
        #battery.charging {
          color: #${colorScheme.base0B};
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
          format = "<span color='#${colorScheme.base0D}'>SMAP</span> {}";
        };

        idle_inhibitor = {
          format = "<span color='#${colorScheme.base0D}'>IDLE</span> {icon}";
          format-icons = {
            activated = "OFF";
            deactivated = "ON";
          };
        };

        cpu = {
          format = "<span color='#${colorScheme.base0D}'>CPU</span> {usage}%";
          on-click = "${btop}";
        };

        memory = {
          format = "<span color='#${colorScheme.base0D}'>RAM</span> {percentage}%";
          on-click = "${btop}";
        };

        pulseaudio = {
          format = "<span color='#${colorScheme.base0D}'>VOL</span> {volume}%";
          format-muted = "<span color='#${colorScheme.base0D}'>MUT</span>";
          format-bluetooth = "<span color='#${colorScheme.base0D}'>BT</span> {volume}%";
          tooltip-format = "{desc} {volume}%";
          on-click = "${mute}";
          on-click-right = "${pavucontrol}";
        };

        network = {
          format-wifi = "<span color='#${colorScheme.base0D}'>WLAN</span> {essid}";
          format-ethernet = "<span color='#${colorScheme.base0D}'>{ifname}</span> {ipaddr}/{cidr}";
          format-linked = "<span color='#${colorScheme.base0D}'>{ifname}</span> No IP";
          format-disconnected = "Not connected";
          format-alt = "<span color='#${colorScheme.base0D}'>{ifname}</span> {ipaddr}/{cidr}";
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
          format = "<span color='#${colorScheme.base0D}'>BAT</span> {capacity}%";
          format-charging = "<span color='#${colorScheme.base0D}'>CHG</span> {capacity}%";
          max-length = 25;
        };

        clock = {
          format = "{:<span color='#${colorScheme.base0D}'>%b %d</span> %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:<span color='#${colorScheme.base0D}'>%A %B</span> %d %Y}";
        };
      }];
    };
  };
}
