{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.niri;

  palette = import ./palette.nix;

  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/8g/wallhaven-8gxggk.jpg";
    sha256 = "sha256-mbQQPS+lrXWnuStrf43PR8c8T2WsPt2hAWcFuiiouRI=";
  };
in
{
  options.desktop'.niri.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--user-menu"
        "--asterisks"
        "--cmd niri-session"
      ];
    };

    programs.niri.enable = true;

    user'.extraGroups = [
      "networkmanager"
      "video"
    ];

    networking.networkmanager.enable = true;
    programs.nm-applet.enable = true;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    services.tuned = {
      enable = true;
      settings.dynamic_tuning = true;
    };

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
      nautilus
      file-roller
      eog
      sushi
    ];
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    preservation' = {
      os.directories = [
        "/var/lib/NetworkManager"
        "/etc/NetworkManager/system-connections"

        "/var/lib/blueman"
        "/var/lib/bluetooth"

        "/var/lib/upower"
        "/var/lib/udisks2"
      ];

      user.directories = [
        ".cache/darkman"
        ".cache/fuzzel"
        ".config/dconf"
        ".local/share/keyrings"
        ".local/state/wireplumber"
      ];
    };

    hm' = {
      imports = [
        (import ./niri.nix palette)
        (import ./waybar.nix palette)
        (import ./fuzzel.nix palette)
        (import ./fnott.nix palette)
      ];

      services.darkman = {
        enable = true;
        darkModeScripts.gtk-theme = /* shell */ ''
          ${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
        lightModeScripts.gtk-theme = /* shell */ ''
          ${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';
      };

      services.swayidle =
        let
          loginctl = lib.getExe' config.systemd.package "loginctl";
          systemctl = lib.getExe' config.systemd.package "systemctl";
        in
        {
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
              command = "${lib.getExe pkgs.gtklock} -d";
            }
            {
              event = "before-sleep";
              command = "${loginctl} lock-session";
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

      services.tailscale-systray.enable = true;
    };
  };
}
