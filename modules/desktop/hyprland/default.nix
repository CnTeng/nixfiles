{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.hyprland;

  inherit (config.users.users.${user}) home;
  inherit (config.desktop'.profiles) colorScheme;
in {
  imports = [../profiles];

  options.desktop'.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    desktop'.profiles = {
      fileManager.enable = true;
      fonts.enable = true;
      idleDaemon.enable = true;
      xdg.enable = true;
    };

    home-manager.users.${user} = let
      getExe' = comp: cmd: "${lib.getBin config.desktop'.profiles.${comp}.package}/bin/${cmd}";

      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/83/wallhaven-83o7j2.jpg";
        sha256 = "sha256-nu8GHG9USaJvZmzvUbBG4xw1x73f1pP+/BEElwboz2k=";
      };
      swaybg = getExe pkgs.swaybg;
      swaylock = getExe pkgs.swaylock-effects;
      terminal = getExe pkgs.kitty;
      launcher = getExe config.desktop'.profiles.launcher.package;
      notify = getExe' "notification" "dunstctl";
      fileManager = getExe' "fileManager" "nemo";
      light = getExe pkgs.light;
      pamixer = getExe pkgs.pamixer;
      playerctl = getExe pkgs.playerctl;
      grim = getExe pkgs.grim;
      hyprpicker = getExe pkgs.hyprpicker;
    in {
      home.packages = with pkgs; [slurp grimblast hyprprop scratchpad];

      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true;
        enableNvidiaPatches = true;
        settings = with colorScheme; {
          general = {
            border_size = 4;
            gaps_in = 3;
            gaps_out = 5;
            "col.inactive_border" = "rgb(${removeHashTag base})";
            "col.active_border" = "rgb(${removeHashTag blue})";
            "col.group_border" = "rgb(${removeHashTag overlay1})";
            "col.group_border_active" = "rgb(${removeHashTag lavender})";
            cursor_inactive_timeout = 30;
            resize_on_border = true;
          };

          dwindle = {
            force_split = 2;
            preserve_split = true;
          };

          decoration = {
            rounding = 5;
            active_opacity = 0.9;
            inactive_opacity = 0.98;
            blur_size = 5;
            blur_passes = 3;
            shadow_range = 12;
            shadow_offset = "3 3";
            "col.shadow" = "rgb(${removeHashTag mantle})";
            "col.shadow_inactive" = "rgb(${removeHashTag crust})";
          };

          input = {
            kb_options = "caps:swapescape";
            numlock_by_default = true;
            repeat_delay = 300;
            scroll_method = "2fg";
            touchpad = {
              natural_scroll = true;
            };
          };

          gestures.workspace_swipe = true;

          misc = {
            disable_hyprland_logo = true;
            animate_manual_resizes = true;
          };

          xwayland.force_zero_scaling = true;

          monitor = [
            "eDP-1, preferred, 0x0, 1.25"
            ", preferred, auto, 1.25"
          ];

          animation = [
            "fade, 1, 3, default"
            "windows, 1, 3, default, slide"
            "workspaces, 1, 6, default, slide"
          ];

          # Startup
          exec-once = ["${swaybg} -m fit -i ${wallpaper}"];

          # Mouse binding
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          bind = [
            # Programs binding
            "SUPER, return, exec, ${terminal}"
            "SUPER, space, exec, ${launcher}"
            "SUPER, E, exec, ${fileManager}"
            "SUPER, N, exec, ${notify} history-pop"

            "SUPER, P, pseudo, # dwindle"
            "SUPER, V, togglesplit, # dwindle"

            # Screenshots
            '', print, exec, ${grim} -g "$(slurp)" "${home}/Pictures/screenshots/$(date '+%y%m%d_%H-%M-%S').png''
            ''SUPER_SHIFT, p, exec, ${grim} -g "$(slurp)" - | wl-copy --type image/png''

            # Colorpicker
            "SUPER_SHIFT, c, exec, ${hyprpicker} --autocopy"

            # Keyboard control
            ", XF86MonBrightnessUP, exec, ${light} -A 5"
            ", XF86MonBrightnessDown, exec, ${light} -U 5"

            ", XF86AudioNext, exec, ${playerctl} next"
            ", XF86AudioPrev, exec, ${playerctl} previous"
            ", XF86AudioPlay, exec, ${playerctl} play-pause"
            ", XF86AudioStop, exec, ${playerctl} stop"

            ", XF86AudioRaiseVolume, exec, ${pamixer} -i 10"
            ", XF86AudioLowerVolume, exec, ${pamixer} -d 10"
            ", XF86AudioMute, exec, ${pamixer} -t"

            # Window manager control
            "SUPER, q, killactive,"

            # bind = SUPER, s, togglesplit # preserve_split must be enabled for toggling to work
            "SUPER, F, fullscreen, 1"
            "SUPER_SHIFT, F, fullscreen, 0"
            "SUPER_SHIFT, space, togglefloating"

            # Change splitratio
            "SUPER, minus, splitratio, -0.25"
            "SUPER, equal, splitratio, 0.25"

            # Grouped windows
            "SUPER, g, togglegroup"
            "SUPER, period, changegroupactive, f"
            "SUPER, comma, changegroupactive, b"

            # Move focus
            "SUPER, k, movefocus, u"
            "SUPER, j, movefocus, d"
            "SUPER, h, movefocus, l"
            "SUPER, l, movefocus, r"
            "SUPER, up, movefocus, u"
            "SUPER, down, movefocus, d"
            "SUPER, left, movefocus, l"
            "SUPER, right, movefocus, r"

            # Move focused window
            "SUPER_SHIFT, k, swapwindow, u"
            "SUPER_SHIFT, j, swapwindow, d"
            "SUPER_SHIFT, h, swapwindow, l"
            "SUPER_SHIFT, l, swapwindow, r"
            "SUPER_SHIFT, up, swapwindow, u"
            "SUPER_SHIFT, down, swapwindow, d"
            "SUPER_SHIFT, left, swapwindow, l"
            "SUPER_SHIFT, right, swapwindow, r"

            # Move focused monitor
            "SUPER_CONTROL, k, focusmonitor, u"
            "SUPER_CONTROL, j, focusmonitor, d"
            "SUPER_CONTROL, h, focusmonitor, l"
            "SUPER_CONTROL, l, focusmonitor, r"
            "SUPER_CONTROL, up, focusmonitor, u"
            "SUPER_CONTROL, down, focusmonitor, d"
            "SUPER_CONTROL, left, focusmonitor, l"
            "SUPER_CONTROL, right, focusmonitor, r"

            # Switch to workspace
            "SUPER, 1, workspace, 1"
            "SUPER, 2, workspace, 2"
            "SUPER, W, workspace, 3"
            "SUPER, D, workspace, 4"
            "SUPER, T, workspace, 5"
            "SUPER, S, workspace, 6"
            "SUPER, 7, workspace, 7"
            "SUPER, 8, workspace, 8"
            "SUPER, 9, workspace, 9"

            # Move focused container to workspace
            "SUPER_SHIFT, 1, movetoworkspace, 1"
            "SUPER_SHIFT, 2, movetoworkspace, 2"
            "SUPER_SHIFT, W, movetoworkspace, 3"
            "SUPER_SHIFT, D, movetoworkspace, 4"
            "SUPER_SHIFT, T, movetoworkspace, 5"
            "SUPER_SHIFT, S, movetoworkspace, 6"
            "SUPER_SHIFT, 7, movetoworkspace, 7"
            "SUPER_SHIFT, 8, movetoworkspace, 8"
            "SUPER_SHIFT, 9, movetoworkspace, 9"

            "SUPER, C, movetoworkspace, special"
          ];

          workspace = [
            "1, monitor:eDP-1, default:true"
            "2, monitor:DP-3, default:true"
            "3, monitor:eDP-1, default:true"
            "4, monitor:eDP-1, default:true"
            "5, monitor:eDP-1, default:true"
            "6, monitor:eDP-1, default:true"
          ];

          bindr = [
            "SUPER, TAB, workspace, e+1" # Move to next open workspace
            "SUPER_SHIFT, TAB, workspace, e-1" # Move to prev open workspace
          ];

          windowrulev2 = [
            "workspace 6, title:^(Spotify)$"

            "opacity 1 override 1 override, class:^(firefox)$"

            "float, class:^(nm-connection-editor)$"
            "float, class:^(.blueman-manager-wrapped)$"
            "float, class:^(org.fcitx.)$"
          ];

          blurls = [
            "waybar"
            "notifications"
            "launcher"
          ];
        };

        extraConfig = ''
          # Exit submap
          bind = SUPER_SHIFT, Escape, submap, Exit
          submap = Exit

          bind = , L, exec, ${playerctl} play-pause
          bind = , L, exec, ${swaylock}
          bind = , L, submap, reset
          bind = , Q, exec, systemctl --user stop graphical-session.target
          bind = , Q, exit,
          bind = , Q, exec, loginctl terminate-session $XDG_SESSION_ID
          bind = , S, exec, systemctl poweroff
          bind = , R, exec, systemctl reboot

          bind = , escape, submap, reset
          submap = reset

          # Resize submap
          bind = SUPER, R, submap, Resize
          submap = Resize

          bind = , k, resizeactive, 0 -20
          bind = , j, resizeactive, 0 20
          bind = , h, resizeactive, -20 0
          bind = , l, resizeactive, 20 0
          bind = , up, resizeactive, 0 -20
          bind = , down, resizeactive, 0 20
          bind = , left, resizeactive, -20 0
          bind = , right, resizeactive, 20 0

          bind = , escape, submap, reset
          submap = reset
        '';
      };
    };
  };
}
