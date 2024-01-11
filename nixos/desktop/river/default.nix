{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.desktop'.river;
in {
  imports = [ ../profiles ];

  options.desktop'.river.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    programs.river = {
      enable = true;
      package = pkgs.river-unstable;
    };

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

    home-manager.users.${user} = {
      xdg.configFile."river/init" = {
        executable = true;
        text = ''
          #!/bin/sh

          # Use the "logo" key as the primary modifier
          mod="Mod4"

          # Mod+Shift+Return to start an instance of foot (https://codeberg.org/dnkl/foot)
          riverctl map normal $mod+Shift Return spawn kitty 

          riverctl map normal $mod Space spawn fuzzel

          riverctl map normal $mod N spawn 'fnottctl dismiss'
          riverctl map normal $mod+Shift N spawn 'fnottctl dismiss all'

          # Mod+Q to close the focused view
          riverctl map normal $mod Q close

          # Mod+Shift+E to exit river
          riverctl map normal $mod+Shift E exit

          # Mod+J and Mod+K to focus the next/previous view in the layout stack
          riverctl map normal $mod T focus-view next
          riverctl map normal $mod S focus-view previous

          # Mod+Shift+J and Mod+Shift+K to swap the focused view with the next/previous
          # view in the layout stack
          riverctl map normal $mod+Shift T swap next
          riverctl map normal $mod+Shift S swap previous

          # Mod+Period and Mod+Comma to focus the next/previous output
          riverctl map normal $mod Period focus-output next
          riverctl map normal $mod Comma focus-output previous

          # Mod+Shift+{Period,Comma} to send the focused view to the next/previous output
          riverctl map normal $mod+Shift G send-to-output next
          riverctl map normal $mod+Shift H send-to-output previous

          # Mod+Return to bump the focused view to the top of the layout stack
          riverctl map normal $mod Return zoom

          # Mod+H and Mod+L to decrease/increase the main ratio of rivertile(1)
          riverctl map normal $mod C send-layout-cmd rivertile "main-ratio -0.05"
          riverctl map normal $mod R send-layout-cmd rivertile "main-ratio +0.05"

          # Mod+Shift+H and Mod+Shift+L to increment/decrement the main count of rivertile(1)
          riverctl map normal $mod+Shift C send-layout-cmd rivertile "main-count +1"
          riverctl map normal $mod+Shift R send-layout-cmd rivertile "main-count -1"

          # Mod+Alt+{H,J,K,L} to move views
          riverctl map normal $mod+Mod1 C move left 100
          riverctl map normal $mod+Mod1 T move down 100
          riverctl map normal $mod+Mod1 S move up 100
          riverctl map normal $mod+Mod1 R move right 100

          # Mod+Alt+Control+{H,J,K,L} to snap views to screen edges
          riverctl map normal $mod+Mod1+Control C snap left
          riverctl map normal $mod+Mod1+Control T snap down
          riverctl map normal $mod+Mod1+Control S snap up
          riverctl map normal $mod+Mod1+Control R snap right

          # Mod+Alt+Shif+{H,J,K,L} to resize views
          riverctl map normal $mod+Mod1+Shift C resize horizontal -100
          riverctl map normal $mod+Mod1+Shift T resize vertical 100
          riverctl map normal $mod+Mod1+Shift S resize vertical -100
          riverctl map normal $mod+Mod1+Shift R resize horizontal 100

          # Mod + Left Mouse Button to move views
          riverctl map-pointer normal $mod BTN_LEFT move-view

          # Mod + Right Mouse Button to resize views
          riverctl map-pointer normal $mod BTN_RIGHT resize-view

          tag() {
              riverctl map normal $mod $1 set-focused-tags $2
              riverctl map normal $mod+Shift $1 set-view-tags $2
              riverctl map normal $mod+Control $1 toggle-focused-tags $2
              riverctl map normal $mod+Shift+Control $1 toggle-view-tags $2
          }

          tag quotedbl 1
          tag guillemotleft 2
          tag guillemotright 4
          tag parenleft 8
          tag parenright 16
          tag at 32
          tag plus 64
          tag minus 128
          tag slash 256

          # for i in $(seq 1 9)
          # do
          #     tags=$((1 << ($i - 1)))

          #     # Mod+[1-9] to focus tag [0-8]
          #     riverctl map normal $mod $i set-focused-tags $tags

          #     # Mod+Shift+[1-9] to tag focused view with tag [0-8]
          #     riverctl map normal $mod+Shift $i set-view-tags $tags

          #     # Mod+Ctrl+[1-9] to toggle focus of tag [0-8]
          #     riverctl map normal $mod+Control $i toggle-focused-tags $tags

          #     # Mod+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
          #     riverctl map normal $mod+Shift+Control $i toggle-view-tags $tags
          # done

          # Mod+0 to focus all tags
          # Mod+Shift+0 to tag focused view with all tags
          all_tags=$(((1 << 32) - 1))
          riverctl map normal $mod 0 set-focused-tags $all_tags
          riverctl map normal $mod+Shift 0 set-view-tags $all_tags

          # Mod+Space to toggle float
          # riverctl map normal $mod Space toggle-float

          # Mod+F to toggle fullscreen
          riverctl map normal $mod F toggle-fullscreen

          # Mod+{Up,Right,Down,Left} to change layout orientation
          riverctl map normal $mod Up    send-layout-cmd rivertile "main-location top"
          riverctl map normal $mod Right send-layout-cmd rivertile "main-location right"
          riverctl map normal $mod Down  send-layout-cmd rivertile "main-location bottom"
          riverctl map normal $mod Left  send-layout-cmd rivertile "main-location left"

          # Declare a passthrough mode. This mode has only a single mapping to return to
          # normal mode. This makes it useful for testing a nested wayland compositor
          riverctl declare-mode passthrough

          # Mod+F11 to enter passthrough mode
          riverctl map normal $mod F11 enter-mode passthrough

          # Mod+F11 to return to normal mode
          riverctl map passthrough $mod F11 enter-mode normal

          # Various media key mapping examples for both normal and locked mode which do
          # not have a modifier
          for mode in normal locked
          do
              # Eject the optical drive (well if you still have one that is)
              riverctl map $mode None XF86Eject spawn 'eject -T'

              # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
              riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
              riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
              riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

              # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
              riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
              riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
              riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
              riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

              # Control screen backlight brighness with light (https://github.com/haikarainen/light)
              riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
              riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
          done

          # Set background and border color
          riverctl background-color 0x002b36
          riverctl border-color-focused 0x93a1a1
          riverctl border-color-unfocused 0x586e75

          # Set keyboard repeat rate
          riverctl set-repeat 50 300

          # Make certain views start floating
          riverctl float-filter-add app-id float
          riverctl float-filter-add title "popup title with spaces"

          # Set app-ids and titles of views which should use client side decorations

          for mouse in $(riverctl list-inputs | sed -n 'N;/Mouse[^\n]*\n\s\+type:\s\+pointer/P;D'); do
              riverctl input $mouse accel-profile flat
              riverctl input $mouse middle-emulation enabled
          done

          for touchpad in $(riverctl list-inputs | sed -n 'N;/Touchpad[^\n]*\n\s\+type:\s\+pointer/P;D'); do
              riverctl input $touchpad tap enabled
              riverctl input $touchpad natural-scroll enabled
              riverctl input $touchpad disable-while-typing disabled
          done

          export XDG_CURRENT_DESKTOP=river
          systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          systemctl --user start river-session.target

          riverctl default-layout grid
        '';
      };

    };
  };
}
