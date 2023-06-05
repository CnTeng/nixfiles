{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.hyprland;

  inherit (config.users.users.${user}) home;
  inherit (config.basics') colorScheme;
  inherit (import ./lib.nix config lib) mkKeymap mkSubmap mkOpacity mkFloat mkBlurls mkSectionStr getExe';
in {
  imports = [../components];
  options.desktop'.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    programs = {
      dconf.enable = true;
      xwayland.enable = true;
    };

    security.polkit.enable = true;

    home-manager.users.${user} = let
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/83/wallhaven-83o7j2.jpg";
        sha256 = "sha256-nu8GHG9USaJvZmzvUbBG4xw1x73f1pP+/BEElwboz2k=";
      };
      swaybg = lib.getExe pkgs.swaybg;
      swaylock = lib.getExe pkgs.swaylock-effects;
      terminal = lib.getExe pkgs.kitty;
      launcher = lib.getExe config.desktop'.components.launcher.package;
      notify = getExe' "notification" "dunstctl";
      fileManager = getExe' "fileManager" "nemo";
      light = lib.getExe pkgs.light;
      pamixer = lib.getExe pkgs.pamixer;
      playerctl = lib.getExe pkgs.playerctl;
      grim = lib.getExe pkgs.grim;
      hyprpicker = lib.getExe pkgs.hyprpicker;
    in {
      home.packages = with pkgs; [
        slurp
        grimblast
        hyprprop
        scratchpad
      ];

      imports = [inputs.hyprland.homeManagerModules.default];

      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true; # Enable hyprland-session.target
        extraConfig = let
          general = {
            border_size = 4;
            gaps_in = 3;
            gaps_out = 5;
            "col.inactive_border" = "rgb(${colorScheme.base})";
            "col.active_border" = "rgb(${colorScheme.blue})";
            "col.group_border" = "rgb(${colorScheme.overlay1})";
            "col.group_border_active" = "rgb(${colorScheme.lavender})";
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
            blur_size = 3;
            blur_passes = 3;
            shadow_range = 12;
            shadow_offset = "3 3";
            "col.shadow" = "rgb(${colorScheme.mantle})";
            "col.shadow_inactive" = "rgb(${colorScheme.crust})";
          };

          input = {
            kb_options = "caps:swapescape";
            numlock_by_default = true;
            repeat_delay = 300;
            scroll_method = "2fg";
            touchpad = {
              outPath = ''
                {
                    natural_scroll = true
                  }
              '';
            };
          };

          gestures = {
            workspace_swipe = true;
          };

          misc = {
            disable_hyprland_logo = true;
            animate_manual_resizes = true;
          };
          debug = {
            disable_logs = true;
          };

          floatWindows = [
            "class:^(nm-connection-editor)$"
            "class:^(.blueman-manager-wrapped)$"
            "class:^(org.fcitx.)$"
          ];

          blurlsNamespaces = [
            "waybar"
            "notifications"
            "wofi"
          ];
        in ''
          monitor = eDP-1, preferred, 0x0, 1
          monitor = , preferred, auto, 1

          ${mkSectionStr "general" general}
          ${mkSectionStr "dwindle" dwindle}
          ${mkSectionStr "decoration" decoration}
          ${mkSectionStr "input" input}
          ${mkSectionStr "gestures" gestures}
          ${mkSectionStr "misc" misc}
          ${mkSectionStr "debug" debug}

          animation = fade, 1, 3, default
          animation = windows, 1, 3, default, slide
          animation = workspaces, 1, 6, default, slide

          # Startup
          exec-once = ${swaybg} -m fit -i ${wallpaper}
          exec-once = hyprctl setcursor Catppuccin-Macchiato-Dark-Cursors 32

          # Hidpi for xwayland, but can't work
          # exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

          # Mouse binding
          bindm = SUPER, mouse:272, movewindow
          bindm = SUPER, mouse:273, resizewindow

          # Programs binding
          bind = SUPER, return, exec, ${terminal}
          bind = SUPER, space, exec, ${launcher}
          bind = SUPER, E, exec, ${fileManager}
          bind = SUPER, N, exec, ${notify} history-pop

          bind = SUPER, P, pseudo, # dwindle
          bind = SUPER, V, togglesplit, # dwindle

          # Screenshots
          bind = , print, exec, ${grim} -g "$(slurp)" "${home}/Pictures/screenshots/$(date '+%y%m%d_%H-%M-%S').png"
          bind = SUPER_SHIFT, p, exec, ${grim} -g "$(slurp)" - | wl-copy --type image/png

          # Colorpicker
          bind = SUPER_SHIFT, c, exec, ${hyprpicker} --autocopy

          # Keyboard control
          bind = , XF86MonBrightnessUP, exec, ${light} -A 5
          bind = , XF86MonBrightnessDown, exec, ${light} -U 5

          bind = , XF86AudioNext, exec, ${playerctl} next
          bind = , XF86AudioPrev, exec, ${playerctl} previous
          bind = , XF86AudioPlay, exec, ${playerctl} play-pause
          bind = , XF86AudioStop, exec, ${playerctl} stop

          bind = , XF86AudioRaiseVolume, exec, ${pamixer} -i 10
          bind = , XF86AudioLowerVolume, exec, ${pamixer} -d 10
          bind = , XF86AudioMute, exec, ${pamixer} -t

          # Window manager control
          bind = SUPER, q, killactive,

          # bind = SUPER, s, togglesplit # preserve_split must be enabled for toggling to work
          bind = SUPER, F, fullscreen, 1
          bind = SUPER_SHIFT, F, fullscreen, 0
          bind = SUPER_SHIFT, space, togglefloating

          # Change splitratio
          bind = SUPER, minus, splitratio, -0.25
          bind = SUPER, equal, splitratio, 0.25

          # Grouped windows
          bind = SUPER, g, togglegroup
          bind = SUPER, period, changegroupactive, f
          bind = SUPER, comma, changegroupactive, b

          # Move focus
          ${mkKeymap
            "SUPER" ["k" "j" "h" "l" "up" "down" "left" "right"]
            "movefocus" ["u" "d" "l" "r" "u" "d" "l" "r"]}

          # Move focused window
          ${mkKeymap
            "SUPER_SHIFT" ["k" "j" "h" "l" "up" "down" "left" "right"]
            "swapwindow" ["u" "d" "l" "r" "u" "d" "l" "r"]}

          # Move focused monitor
          ${mkKeymap
            "SUPER_CONTROL" ["k" "j" "h" "l" "up" "down" "left" "right"]
            "focusmonitor" ["u" "d" "l" "r" "u" "d" "l" "r"]}

          ${mkSubmap "Exit" "SUPER_SHIFT, Escape"
            ''
              bind = , S, exec, ${swaylock}
              bind = , S, submap, reset
              bind = , Q, exec, systemctl --user stop graphical-session.target
              bind = , Q, exit,
              bind = , Q, exec, loginctl terminate-session $XDG_SESSION_ID
              bind = , P, exec, systemctl poweroff
              bind = , R, exec, systemctl reboot
            ''}

          # Resize submap
          ${mkSubmap "Resize" "SUPER, R"
            (mkKeymap
              "" ["k" "j" "h" "l" "up" "down" "left" "right"]
              "resizeactive" ["0 -20" "0 20" "-20 0" "20 0" "0 -20" "0 20" "-20 0" "20 0"])}

          # Switch to workspace
          ${mkKeymap
            "SUPER" ["1" "2" "W" "D" "T" "S" "7" "8" "9"]
            "workspace" ["1" "2" "3" "4" "5" "6" "7" "8" "9"]}


          # Move focused container to workspace
          ${mkKeymap
            "SUPER_SHIFT" ["1" "2" "W" "D" "T" "S" "7" "8" "9"]
            "movetoworkspace" ["1" "2" "3" "4" "5" "6" "7" "8" "9"]}

          workspace = 1, monitor:eDP-1, default:true
          workspace = 2, monitor:DP-3, default:true
          workspace = 3, monitor:eDP-1, default:true
          workspace = 4, monitor:eDP-1, default:true
          workspace = 5, monitor:eDP-1, default:true
          workspace = 6, monitor:eDP-1, default:true

          bind = SUPER, C, movetoworkspace, special

          bindr = SUPER, TAB, workspace, e+1 # Move to next open workspace
          bindr = SUPER_SHIFT, TAB, workspace, e-1 # Move to prev open workspace

          windowrulev2 = workspace 6, title:^(Spotify)$

          ${mkOpacity "1 override 1 override" ["class:^(firefox)$"]}

          ${mkFloat floatWindows}

          ${mkBlurls blurlsNamespaces}
        '';
      };
    };
  };
}
