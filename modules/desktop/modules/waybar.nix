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
    # Maybe necessary for tray
    home.packages = with pkgs; [
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
          color: #${base05};
          opacity: 0.9;
          background-color: #${base00};
          padding: 0;
          border-radius: 10px;
        }

        #custom-nixos {
          color: #${base05};
          background-color: #${base00};
          border-radius: 10px;
          padding-left: 15px;
          padding-right: 20px;
        }

        #custom-separator {
          color: #${base05};
          margin: 0 6px;
        }

        #workspaces {
          color: #${base05};
          background-color: #${base00};
          border-radius: 0;
        }
        #workspaces button {
          padding: 0 15px;
          border-radius: 0;
        }
        #workspaces button.hidden {
          color: #${base05};
          background-color: #${base00};
        }
        #workspaces button.focused,
        #workspaces button.active {
          color: #${base05};
          background-color: #${base02};
          border-bottom: 4px solid #${base0D};
          padding: 8px 15px 4px;
        }
        #workspaces button.urgent {
          color: #${base05};
          background-color: #${base09};
          border-bottom: 4px solid #${base0D};
          padding: 8px 15px 4px;
        }

        #submap {
          color: #${base05};
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
          color: #${base05};
        }

        #clock {
          color: #${base05};
          margin-right: 15px;
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
          format = "<span color='#${base0D}'>SMAP</span> {}";
        };

        idle_inhibitor = {
          format = "<span color='#${base0D}'>IDLE</span> {icon}";
          format-icons = {
            activated = "OFF";
            deactivated = "ON";
          };
        };

        cpu = {
          format = "<span color='#${base0D}'>CPU</span> {usage}%";
          on-click = "${btop}";
        };

        memory = {
          format = "<span color='#${base0D}'>RAM</span> {percentage}%";
          on-click = "${btop}";
        };

        pulseaudio = {
          format = "<span color='#${base0D}'>VOL</span> {volume}%";
          format-muted = "<span color='#${base0D}'>MUT</span>";
          format-bluetooth = "<span color='#${base0D}'>BT</span> {volume}%";
          tooltip-format = "{desc} {volume}%";
          on-click = "${mute}";
          on-click-right = "${pavucontrol}";
        };

        network = {
          format-wifi = "<span color='#${base0D}'>WLAN</span> {essid}";
          format-ethernet = "<span color='#${base0D}'>{ifname}</span> {ipaddr}/{cidr}";
          format-linked = "<span color='#${base0D}'>{ifname}</span> No IP";
          format-disconnected = "Not connected";
          format-alt = "<span color='#${base0D}'>{ifname}</span> {ipaddr}/{cidr}";
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
          format = "<span color='#${base0D}'>BAT</span> {capacity}%";
          format-charging = "<span color='#${base0D}'>CHG</span> {capacity}%";
          max-length = 25;
        };

        clock = {
          format = "{:<span color='#${base0D}'>%b %d</span> %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:<span color='#${base0D}'>%A %B</span> %d %Y}";
        };
      }];
    };
  };
}
