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

  systemctl = lib.getExe' config.systemd.package "systemctl";
  loginctl = lib.getExe' config.systemd.package "loginctl";

  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/5g/wallhaven-5gx2q5.png";
    sha256 = "sha256-2gpyEJ9GkTCnVMYbreKXB6QJTVvKc2Up8LHoPCHJ9Os=";
  };
in
{
  options.desktop'.niri.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = true;
    programs.niri.enable = true;

    users.users.${user}.extraGroups = [
      "networkmanager"
      "video"
    ];

    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;
    systemd.user.services.nm-applet.after = [ "graphical-session.target" ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    services.dbus.implementation = "broker";
    services.gvfs.enable = true;
    services.gnome.at-spi2-core.enable = true;
    services.playerctld.enable = true;

    security.pam.services.gtklock = { };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      nautilus
      eog
    ];
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

    programs.file-roller.enable = true;
    services.gnome.sushi.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.persistence."/persist" = {
      directories = [ "/etc/NetworkManager/system-connections" ];
      users.${user}.directories = [
        ".cache/fuzzel"
        ".config/dconf"
        ".local/share/keyrings"
        ".local/state/wireplumber"
      ];
    };

    home-manager.users.${user} =
      { config, ... }:
      {
        imports = [
          (import ./niri.nix { inherit palette; })
          (import ./waybar.nix { inherit palette; })
        ];

        services.poweralertd.enable = true;

        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              font = "Adwaita Mono:size=13";
              dpi-aware = "no";
              icon-theme = "Papirus-Dark";
              anchor = "top";
              y-margin = 8;
              lines = 5;
              width = 50;
              horizontal-pad = 24;
              cache = "${config.xdg.cacheHome}/fuzzel/cache";
            };
            colors = {
              background = lib.removeHashTag palette.dialog_bg_color + "ff";
              text = lib.removeHashTag palette.dialog_fg_color + "ff";
              prompt = lib.removeHashTag palette.dialog_fg_color + "ff";
              input = lib.removeHashTag palette.dialog_fg_color + "ff";
              match = lib.removeHashTag palette.accent_color + "ff";
              selection = lib.removeHashTag palette.selected_bg_color + "ff";
              selection-text = lib.removeHashTag palette.selected_fg_color + "ff";
              selection-match = lib.removeHashTag palette.accent_color + "ff";
            };
            border = {
              width = 0;
              radius = 16;
            };
          };
        };

        services.fnott = {
          enable = true;
          settings = {
            main = {
              min-width = 500;
              max-width = 500;
              max-height = 200;
              edge-margin-vertical = 8;
              edge-margin-horizontal = 8;
              icon-theme = "Papirus-Dark";
              max-icon-size = 96;

              background = lib.removeHashTag palette.dialog_bg_color + "ff";
              border-radius = 16;
              border-size = 0;

              title-font = "Adwaita Mono:size=10";
              title-format = "<b>%a%A</b>";
              summary-font = "Adwaita Mono:size=10";
              summary-format = "%s\n";
              body-font = "Adwaita Mono:size=10";

              max-timeout = 15;
              default-timeout = 15;
              idle-timeout = 15;
            };
            low = {
              background = lib.removeHashTag palette.dialog_bg_color + "ff";
              title-color = lib.removeHashTag palette.dialog_fg_color + "ff";
              summary-color = lib.removeHashTag palette.dialog_fg_color + "ff";
              body-color = lib.removeHashTag palette.dialog_fg_color + "ff";
            };
            critical = {
              background = lib.removeHashTag palette.error_bg_color + "ff";
            };
          };
        };

        systemd.user.services.gtklock = {
          Unit = {
            ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "forking";
            ExecStartPre = "${lib.getExe pkgs.niri} msg action do-screen-transition --delay-ms 1000";
            ExecStart = "${lib.getExe pkgs.gtklock} --daemonize";
            ExecStartPost = "${lib.getExe' pkgs.coreutils "sleep"} 3";
          };
        };

        xdg.configFile."gtklock/config.ini".source = (pkgs.formats.ini { }).generate "config.ini" {
          main = {
            modules = "${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so";
            background = wallpaper;
            follow-focus = true;
            start-hidden = true;
          };
          powerbar.show-labels = true;
        };

        services.swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = 600;
              command = "${loginctl} lock-session";
            }
            {
              timeout = 900;
              command = "${systemctl} suspend";
            }
          ];
          events = [
            {
              event = "lock";
              command = "${systemctl} --user start gtklock";
            }
            {
              event = "unlock";
              command = "${systemctl} --user stop gtklock";
            }
            {
              event = "before-sleep";
              command = "${systemctl} --user start gtklock";
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
            ExecStart = "${lib.getExe pkgs.xwayland-satellite} :1";
            Environment = "RUST_LOG=error";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        systemd.user.services.swaybg = {
          Unit = {
            Description = "Wallpaper tool for Wayland compositors";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
  };
}
