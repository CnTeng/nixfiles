{ pkgs, hyprland, ... }:

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

  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  wallpaper = "$HOME/OneDrive/Pictures/wallpapers/digital_sea.jpg";
  swaybg = "${pkgs.swaybg}/bin/swaybg";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  terminal = "${pkgs.kitty}/bin/kitty";
  rofi = "rofi -show drun";
  pcmanfm = "${pkgs.pcmanfm}/bin/pcmanfm";
  light = "${pkgs.light}/bin/light";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
in
{
  imports = [ hyprland.homeManagerModules.default ];

  programs.zsh = {
    loginExtra = ''
      # If running from tty1 start hyprland
      [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
    '';
  };

  # Find options from https://github.com/hyprwm/Hyprland/blob/main/nix/hm-module.nix
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true; # Enable hyprland-session.target
    recommendedEnvironment = false;
    extraConfig = ''
      monitor=eDP-1,1920x1080@60,0x0,1
      monitor=,preferred,auto,1

      workspace=DP-3,2

      general {
        main_mod=SUPER
        border_size=4
        gaps_in=3
        gaps_out=5
        col.active_border=rgb(${base0D})
        col.inactive_border=rgb(${base00})
        cursor_inactive_timeout=30
        layout=dwindle
      }
      
      decoration {
        rounding=5
        multisample_edges=true
        active_opacity=1
        inactive_opacity=1
        fullscreen_opacity=1
        blur=true
        blur_new_optimizations=true
        blur_ignore_opacity=true
        drop_shadow=false
      }

      animations {
        enabled=true
        animation=fade,1,3,default
        animation=windows,1,3,default,slide
        animation=workspaces,1,6,default,slide
      }

      dwindle {
        col.group_border_active=rgb(${base0B})
        col.group_border=rgb(${base00})
        force_split=2
      }

      input {
        kb_layout=us
        kb_options=caps:swapescape
        follow_mouse=1
        repeat_delay=250
        natural_scroll=false
        numlock_by_default=true
        force_no_accel=true
        sensitivity=-0.8
        touchpad {
          natural_scroll=true
        }
      }
      
      gestures {
        workspace_swipe=true
        workspace_swipe_distance=100
        workspace_swipe_create_new=false
      }

      misc {
        disable_hyprland_logo=true
      }

      # Startup
      exec-once=${swaybg} -m fit -i ${wallpaper}
      exec-once=fcitx5
      # Hidpi for xwayland, but can't work
      # exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

      # Mouse binding
      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow

      # Programs binding
      bind=SUPER,return,exec,${terminal}
      bind=SUPER,space,exec,${rofi}
      bind=SUPER,e,exec,${pcmanfm}

      # Screenshots
      bind=,print,exec,${grim} -g "$(${slurp})" | ${wl-copy}


      # Keyboard control
      bind=,XF86MonBrightnessUP,exec,${light} -A 5
      bind=,XF86MonBrightnessDown,exec,${light} -U 5

      bind=,XF86AudioNext,exec,${playerctl} next
      bind=,XF86AudioPrev,exec,${playerctl} previous
      bind=,XF86AudioPlay,exec,${playerctl} play-pause
      bind=,XF86AudioStop,exec,${playerctl} stop

      bind=,XF86AudioRaiseVolume,exec,${pamixer} -i 10
      bind=,XF86AudioLowerVolume,exec,${pamixer} -d 10
      bind=,XF86AudioMute,exec,${pamixer} -t

      # Window manager control
      bind=SUPER,q,killactive,
      bind=SUPER_SHIFT,s,exec,${swaylock} # Lock the screen
      bind=SUPER_SHIFT,escape,exit,
      bind=SUPER_SHIFT,escape,exec,systemctl --user stop graphical-session.target
      bind=SUPER_SHIFT,escape,exec,systemctl --user stop hyprland-session.target

      # bind=SUPER,s,togglesplit # preserve_split must be enabled for toggling to work
      bind=SUPER,f,fullscreen,1
      bind=SUPER_SHIFT,F,fullscreen,0
      bind=SUPER_SHIFT,space,togglefloating

      # Change splitratio
      bind=SUPER,minus,splitratio,-0.25
      bind=SUPER,equal,splitratio,0.25

      # Grouped windows
      bind=SUPER,g,togglegroup
      bind=SUPER,period,changegroupactive,f
      bind=SUPER,comma,changegroupactive,b

      # Move focus
      bind=SUPER,k,movefocus,u
      bind=SUPER,j,movefocus,d
      bind=SUPER,h,movefocus,l
      bind=SUPER,l,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d
      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r

      # Move focused window
      bind=SUPER_SHIFT,k,movewindow,u
      bind=SUPER_SHIFT,j,movewindow,d
      bind=SUPER_SHIFT,h,movewindow,l
      bind=SUPER_SHIFT,l,movewindow,r
      bind=SUPER_SHIFT,up,movewindow,u
      bind=SUPER_SHIFT,down,movewindow,d
      bind=SUPER_SHIFT,left,movewindow,l
      bind=SUPER_SHIFT,right,movewindow,r

      # Move focused monitor
      bind=SUPER_CONTROL,k,focusmonitor,u
      bind=SUPER_CONTROL,j,focusmonitor,d
      bind=SUPER_CONTROL,h,focusmonitor,l
      bind=SUPER_CONTROL,l,focusmonitor,r
      bind=SUPER_CONTROL,up,focusmonitor,u
      bind=SUPER_CONTROL,down,focusmonitor,d
      bind=SUPER_CONTROL,left,focusmonitor,l
      bind=SUPER_CONTROL,right,focusmonitor,r

      bind=SUPER_CONTROL,1,focusmonitor,eDP-1
      bind=SUPER_CONTROL,2,focusmonitor,DP-3

      # Move focused window to monitor
      bind=SUPER_CONTROL_SHIFT,k,movewindow,mon:u
      bind=SUPER_CONTROL_SHIFT,j,movewindow,mon:d
      bind=SUPER_CONTROL_SHIFT,h,movewindow,mon:l
      bind=SUPER_CONTROL_SHIFT,l,movewindow,mon:r
      bind=SUPER_CONTROL_SHIFT,up,movewindow,mon:u
      bind=SUPER_CONTROL_SHIFT,down,movewindow,mon:d
      bind=SUPER_CONTROL_SHIFT,left,movewindow,mon:l
      bind=SUPER_CONTROL_SHIFT,right,movewindow,mon:r

      bind=SUPER_CONTROL_SHIFT,1,movewindow,mon:eDP-1
      bind=SUPER_CONTROL_SHIFT,2,movewindow,mon:DP-2

      # Resize window
      bind=SUPER,r,submap,resize # Switch to resize submap
      submap=resize

      binde=,k,resizeactive,0 -20
      binde=,j,resizeactive,0 20
      binde=,h,resizeactive,-20 0
      binde=,l,resizeactive,20 0
      binde=,up,resizeactive,0 -20
      binde=,down,resizeactive,0 20
      binde=,left,resizeactive,-20 0
      binde=,right,resizeactive,20 0

      bind=,escape,submap,reset 
      submap=reset # Back to global submap

      # Switch to workspace
      bind=SUPER,1,workspace,1
      bind=SUPER,2,workspace,2
      bind=SUPER,3,workspace,3
      bind=SUPER,4,workspace,4
      bind=SUPER,5,workspace,5
      bind=SUPER,6,workspace,6
      bind=SUPER,7,workspace,7
      bind=SUPER,8,workspace,8
      # bind=SUPER,9,workspace,9
      # bind=SUPER,0,workspace,10
      bindr=SUPER,TAB,workspace,e+1 # Move to next open workspace
      bindr=SUPER_SHIFT,TAB,workspace,e-1 # Move to prev open workspace

      # Move focused container to workspace
      bind=SUPER_SHIFT,1,movetoworkspace,1
      bind=SUPER_SHIFT,2,movetoworkspace,2
      bind=SUPER_SHIFT,3,movetoworkspace,3
      bind=SUPER_SHIFT,4,movetoworkspace,4
      bind=SUPER_SHIFT,5,movetoworkspace,5
      bind=SUPER_SHIFT,6,movetoworkspace,6
      bind=SUPER_SHIFT,7,movetoworkspace,7
      bind=SUPER_SHIFT,8,movetoworkspace,8
      # bind=SUPER_SHIFT,9,movetoworkspace,9
      # bind=SUPER_SHIFT,0,movetoworkspace,10

      windowrulev2=opacity 0.95,class:^(kitty)$
      windowrulev2=tile,class:^(Spotify)$
      windowrulev2=opacity 0.95,class:^(Spotify)$
      windowrulev2=float,class:^(nm-connection-editor)$
      windowrulev2=float,class:^(.blueman-manager-wrapped)$
      windowrulev2=float,class:^(org.fcitx.)$
    '';
  };
}
