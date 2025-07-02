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
    url = "https://w.wallhaven.cc/full/8g/wallhaven-8gxggk.jpg";
    sha256 = "sha256-mbQQPS+lrXWnuStrf43PR8c8T2WsPt2hAWcFuiiouRI=";
  };
in
{
  options.desktop'.niri.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      vt = 7;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.greetd.tuigreet)
        "--time"
        "--user-menu"
        "--asterisks"
        "--cmd niri-session"
      ];
    };

    programs.niri.enable = true;

    users.users.${user}.extraGroups = [
      "networkmanager"
      "video"
    ];

    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    services.upower.enable = true;

    services.dbus.implementation = "broker";
    services.gvfs.enable = true;
    services.gnome.at-spi2-core.enable = true;
    services.playerctld.enable = true;

    programs.gtklock = {
      enable = true;
      config = {
        main = {
          background = builtins.toString wallpaper;
          follow-focus = true;
          start-hidden = true;
        };
        powerbar.show-labels = true;
      };
      modules = [ pkgs.gtklock-powerbar-module ];
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
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
    programs.evince.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    preservation.preserveAt."/persist" = {
      directories = [
        "/var/lib/NetworkManager"
        "/etc/NetworkManager/system-connections"

        "/var/lib/blueman"
        "/var/lib/bluetooth"

        "/var/lib/upower"
        "/var/lib/udisks2"
      ];
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
          (import ./niri.nix palette)
          (import ./waybar.nix palette)
          (import ./fuzzel.nix palette)
          (import ./fnott.nix palette)
        ];

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
