{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.hyprland;

  inherit (config.basics'.colors) palette;
in {
  imports = [../profiles];

  options.desktop'.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    desktop'.profiles = {
      console.enable = true;
      fonts.enable = true;
      idle.enable = true;
      inputMethod.enable = true;
      login.enable = true;
      opengl.enable = true;
      services.enable = true;
      theme.enable = true;
      utils.enable = true;
      variables.enable = true;
      wallpaper.enable = true;
      waybar.enable = true;
      wireless.enable = true;
      xdg.enable = true;
    };

    home-manager.users.${user} = let
      getUtil = name: config.desktop'.profiles.utils.packages.${name}.exec;

      terminal = getUtil "terminal";
      launcher = getUtil "launcher";
      notify = getUtil "notify";
      fileManager = getUtil "fileManager";
      brightctl = getUtil "brightctl";
      pamixer = getExe pkgs.pamixer;
      playerctl = getUtil "playerctl";
      screenshot = getUtil "screenshot";
    in {
      wayland.windowManager.hyprland = with palette; {
        enable = true;
        systemd.enable = true;
        settings = {
          general = {
            border_size = 3;
            gaps_in = 3;
            gaps_out = 5;
            "col.active_border" = "rgba(${removeHashTag text.hex}e6)";
            "col.inactive_border" = "rgba(${removeHashTag base.hex}e6)";
            cursor_inactive_timeout = 30;
            resize_on_border = true;
          };

          dwindle = {
            force_split = 2;
            preserve_split = true;
          };

          decoration = {
            rounding = 6;
            active_opacity = 0.9;
            inactive_opacity = 0.98;
            shadow_range = 20;
            shadow_offset = "3 3";
            "col.shadow" = "rgba(${removeHashTag crust.hex}e6)";
            "col.shadow_inactive" = "rgba(${removeHashTag crust.hex}00)";
            blur = {
              size = 5;
              passes = 3;
            };
          };

          input = {
            kb_options = config.services.xserver.xkbOptions;
            numlock_by_default = true;
            repeat_delay = 300;
            scroll_method = "2fg";
            touchpad = {
              natural_scroll = true;
            };
          };

          gestures.workspace_swipe = true;

          group = {
            "col.border_active" = "rgba(${removeHashTag blue.hex}e6)";
            "col.border_inactive" = "rgba(${removeHashTag base.hex}e6)";
            groupbar = {
              gradients = false;
              render_titles = false;
              "col.active" = "rgba(${removeHashTag blue.hex}e6)";
              "col.inactive" = "rgba(${removeHashTag base.hex}00)";
            };
          };

          misc = {
            disable_hyprland_logo = true;
            animate_manual_resizes = true;
          };

          xwayland.force_zero_scaling = true;

          monitor = [
            "eDP-1, preferred, auto, 1.25"
            ", preferred, auto, 1.25"
          ];

          animation = [
            "fade, 1, 3, default"
            "windows, 1, 3, default, slide"
            "workspaces, 1, 6, default, slide"
          ];

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
            '', print, exec, ${screenshot} --notify --freeze copysave area''
            ''SUPER_SHIFT, p, exec, ${screenshot} --notify --freeze copy area''

            # Keyboard control
            ", XF86MonBrightnessUP, exec, ${brightctl} -u 300000 -A 5"
            ", XF86MonBrightnessDown, exec, ${brightctl} -u 300000 -U 5"

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
            "opacity 1 override 1 override, class:^(google-chrome)$"

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

          bind = , L, exec, loginctl lock-session
          bind = , L, submap, reset
          bind = , Q, exec, systemctl --user stop graphical-session.target
          bind = , Q, exec, loginctl terminate-session $XDG_SESSION_ID
          bind = , S, exec, systemctl poweroff
          bind = , R, exec, systemctl reboot

          bind = , escape, submap, reset
          bind = CTRL, [, submap, reset
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

      systemd.user.targets.tray.Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
