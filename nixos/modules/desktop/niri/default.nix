{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.desktop'.niri;
  palette = import ./palette.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/l8/wallhaven-l8dgv2.jpg";
    sha256 = "sha256-dHTiXhzyju9yPVCixe7VMOG9T9FyQG/Hm79zhe0P4wk=";
  };
in
{
  imports = [ ./waybar.nix ];

  options.desktop'.niri.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    niri.profiles.waybar.enable = true;

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      nautilus
      wl-clipboard
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.persistence."/persist" = {
      directories = [ "/etc/NetworkManager/system-connections" ];
      users.${user} = {
        files = [ ".cache/fuzzel" ];
        directories = [
          ".config/dconf"
          ".local/share/keyrings"
          ".local/state/wireplumber"
        ];
      };
    };

    hardware.brillo.enable = true;
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    networking.networkmanager.enable = true;

    users.users.${user}.extraGroups = [
      "networkmanager"
      "video"
    ];

    services.dbus.implementation = "broker";
    services.gvfs.enable = true;
    services.gnome.at-spi2-core.enable = true;

    security.pam.services.gtklock = { };

    programs.file-roller.enable = true;

    home-manager.users.${user} = {
      services.blueman-applet.enable = true;
      services.network-manager-applet.enable = true;

      services.udiskie.enable = true;
      services.playerctld.enable = true;
      services.swayosd.enable = true;

      xsession.preferStatusNotifierItems = true;

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "Noto Sans Mono:size=13";
            icon-theme = "Papirus-Dark";
            anchor = "top";
            lines = 5;
            width = 50;
          };
          colors = {
            background = lib.removeHashTag palette.dark_0 + "e6";
            text = lib.removeHashTag palette.light_1 + "ff";
            match = lib.removeHashTag palette.blue_1 + "ff";
            selection = lib.removeHashTag palette.dark_1 + "ff";
            selection-text = lib.removeHashTag palette.light_1 + "ff";
            selection-match = lib.removeHashTag palette.blue_1 + "ff";
            border = lib.removeHashTag palette.light_1 + "e6";
          };
        };
      };

      services.fnott = {
        enable = true;
        settings = {
          main = {
            title-font = "Noto Sans Mono:size=12";
            summary-font = "Noto Sans Mono:size=12";
            dpi-aware = true;
            border-radius = 10;
            min-width = 500;
            max-width = 500;
            max-icon-size = 128;
            default-timeout = 15;
          };
        };
      };

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 240;
            command = (lib.getExe' pkgs.systemd "loginctl") + " lock-session";
          }
          {
            timeout = 300;
            command = (lib.getExe' pkgs.systemd "systemctl") + " suspend";
          }
        ];
        events = [
          {
            event = "lock";
            command = lib.getExe pkgs.playerctl + " pause";
          }
          {
            event = "lock";
            command = lib.getExe pkgs.gtklock + " -d -S";
          }
        ];
      };

      systemd.user.services.xwayland-satellite = {
        Unit = {
          Description = "Xwayland outside your Wayland";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = lib.getExe pkgs.xwayland-satellite + " :1";
          StandardOutput = "journal";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      systemd.user.services.swaybg = {
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Unit = {
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
          Restart = "on-failure";
        };
      };

      systemd.user.services = {
        blueman-applet.Unit.After = [ "graphical-session.target" ];
        network-manager-applet.Unit.After = [ "graphical-session.target" ];
        udiskie.Unit.After = [ "graphical-session.target" ];
        swayidle.Unit.After = [ "graphical-session.target" ];
        fnott.Unit.After = [ "graphical-session.target" ];
      };

      systemd.user.targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session.target" ];
        };
      };

      xdg.configFile."niri/config.kdl".source = ./niri.kdl;
    };
  };
}
