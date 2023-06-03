{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.notification;
  inherit (config.basics') colorScheme;
  inherit (config.home-manager.users.${user}.gtk) iconTheme;
in {
  options.desktop'.components.notification = {
    enable = mkEnableOption "notification daemon component" // {default = true;};
    package = mkPackageOption pkgs "notification daemon" {
      default = ["dunst"];
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.dunst = {
        enable = true;
        inherit iconTheme;
        settings = with colorScheme; {
          global = {
            follow = "mouse";
            enable_posix_regex = true;
            width = "(0, 300)";
            offset = "5x5";
            progress_bar_corner_radius = 5;
            icon_corner_radius = 5;
            frame_width = 4;
            frame_color = "#${blue}";
            gap_size = 5;
            font = "RobotoMono Nerd Font 15";
            icon_theme = iconTheme.name;
            corner_radius = 10;
            mouse_right_click = "context";
            mouse_left_click = "close_current";

            background = "#${base}e6";
            foreground = "#${text}";
            max_icon_size = 128;
            timeout = 5;
          };

          urgency_critical = {
            frame_color = "#${peach}";
          };
        };
      };
    };
  };
}
