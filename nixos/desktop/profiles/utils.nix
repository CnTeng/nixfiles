{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.utils;
  inherit (config.desktop'.profiles) palette;
  inherit (config.home-manager.users.${user}.gtk) iconTheme;
in {
  options.desktop'.profiles.utils = {
    enable = mkEnableOption "utils component";
    fileManager = mkPackageOption pkgs ["cinnamon" "nemo-with-extensions"] {};
    launcher = mkPackageOption pkgs "fuzzel" {};
    locker = mkPackageOption pkgs "gtklock" {};
    notify = mkPackageOption pkgs "dunst" {};
    wallpaper = mkPackageOption pkgs "swaybg" {};
    terminal = mkPackageOption pkgs "kitty" {};
    brightctl = mkPackageOption pkgs "brillo" {};
    playerctl = mkPackageOption pkgs "playerctl" {};
    screenshot = mkPackageOption pkgs "grimblast" {};
  };

  config = mkIf cfg.enable {
    # file manager
    environment.systemPackages = [cfg.fileManager pkgs.cinnamon.xviewer];
    services.dbus.packages = [cfg.fileManager];
    programs.file-roller.enable = true;

    # brightctl
    users.users.${user}.extraGroups = ["video"];
    hardware.brillo.enable = true;

    # locker
    security.pam.services.gtklock = {};

    home-manager.users.${user} = {
      # file manager
      dconf.settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "kitty";
        "org/nemo/preferences" = {
          close-device-view-on-device-eject = true;
          show-open-in-terminal-toolbar = true;
          show-show-thumbnails-toolbar = true;
          tooltips-in-icon-view = true;
          tooltips-in-list-view = true;
        };
      };

      # launcher
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "RobotoMono Nerd Font:size=15";
            icon-theme = "Papirus-Dark";
            lines = 5;
            width = 50;
          };
          colors = with palette; {
            background = "${removeHashTag base.hex}e6";
            text = "${removeHashTag text.hex}ff";
            match = "${removeHashTag blue.hex}ff";
            selection = "${removeHashTag surface1.hex}ff";
            selection-text = "${removeHashTag text.hex}ff";
            selection-match = "${removeHashTag blue.hex}ff";
            border = "${removeHashTag blue.hex}e6";
          };
        };
      };

      # notify
      services.dunst = with palette; {
        enable = true;
        inherit iconTheme;
        settings = with palette; {
          global = {
            follow = "mouse";
            enable_posix_regex = true;
            width = "(0, 300)";
            offset = "5x5";
            progress_bar_corner_radius = 5;
            icon_corner_radius = 5;
            frame_width = 4;
            frame_color = "${blue.hex}";
            gap_size = 5;
            font = "RobotoMono Nerd Font 15";
            icon_theme = iconTheme.name;
            corner_radius = 10;
            mouse_right_click = "context";
            mouse_left_click = "close_current";
            background = "${base.hex}e6";
            foreground = "${text.hex}";
            max_icon_size = 128;
            timeout = 5;
          };
          urgency_critical = {
            frame_color = "${peach.hex}";
          };
        };
      };
    };
  };
}
