palette:
{ lib, pkgs, ... }:
let
  powerMenu = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = [ pkgs.fuzzel ];
    text = ''
      OPTIONS=(
        " Lock"
        " Suspend"
        " Reboot"
        " Power off"
        " Log out"
      )

      CHOICE=$(printf '%s\n' "''${OPTIONS[@]}" | fuzzel --dmenu --cache /dev/null)

      case $CHOICE in
      *"Lock") loginctl lock-session ;;
      *"Suspend") systemctl suspend ;;
      *"Reboot") systemctl reboot ;;
      *"Power off") systemctl poweroff ;;
      *"Log out") niri msg action quit ;;
      esac
    '';
  };
in
{
  xdg.configFile."niri/config.kdl".text = ''
    debug {
      render-drm-device "/dev/dri/card1"
    }

    spawn-at-startup "xwayland-satellite" ":1"

    prefer-no-csd

    environment { DISPLAY ":1"; }

    hotkey-overlay { skip-at-startup; }

    input {
      keyboard {
        xkb { options "ctrl:nocaps"; }
        repeat-delay 300
        repeat-rate 50
      }
      touchpad {
        tap
        natural-scroll
      }
      focus-follows-mouse max-scroll-amount="10%"
    }

    output "Dell Inc. DELL U2723QX 843R0P3"     { scale 1.75; }
    output "Dell Inc. DELL U2518D 3M7K8013ARCL" { scale 1.25; }

    layout {
      gaps 8
      default-column-width { proportion 1.0; }
      focus-ring {
        width 2
        active-color "${palette.accent_color}"
        inactive-color "${palette.window_bg_color}"
      }
      border { off; }
    }

    window-rule {
      clip-to-geometry true
      geometry-corner-radius 8
      draw-border-with-background false
    }

    window-rule {
      match app-id=r#"firefox$"# title="^(Picture-in-Picture|Library)$"
      match app-id=r#"^nz\.co\.mega\.$"#
      match app-id=r#"^org\.gnome\.NautilusPreviewer$"#
      open-floating true
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }

      Mod+Escape hotkey-overlay-title="Open Power Menu"       { spawn "${lib.getExe powerMenu}"; }
      Mod+Return hotkey-overlay-title="Open Terminal"         { spawn "kitty"; }
      Mod+Space  hotkey-overlay-title="Open Launcher"         { spawn "fuzzel"; }
      Mod+E      hotkey-overlay-title="Open File Manager"     { spawn "nautilus"; }
      Mod+T      hotkey-overlay-title="Quick Access Terminal" { spawn "kitten" "quick-access-terminal"; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86MonBrightnessUp   allow-when-locked=true { spawn "${lib.getExe pkgs.brightnessctl}" "set" "+5%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "${lib.getExe pkgs.brightnessctl}" "set" "5%-"; }

      XF86Display { spawn "${lib.getExe pkgs.wdisplays}"; }

      Mod+O repeat=false { toggle-overview; }

      Mod+Q { close-window; }

      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-down; }
      Mod+K     { focus-window-up; }
      Mod+L     { focus-column-right; }

      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down; }
      Mod+Ctrl+Up    { move-window-up; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down; }
      Mod+Ctrl+K     { move-window-up; }
      Mod+Ctrl+L     { move-column-right; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+Shift+Left  { focus-monitor-left; }
      Mod+Shift+Down  { focus-monitor-down; }
      Mod+Shift+Up    { focus-monitor-up; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+H     { focus-monitor-left; }
      Mod+Shift+J     { focus-monitor-down; }
      Mod+Shift+K     { focus-monitor-up; }
      Mod+Shift+L     { focus-monitor-right; }

      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

      Mod+Page_Down      { focus-workspace-down; }
      Mod+Page_Up        { focus-workspace-up; }
      Mod+N              { focus-workspace-down; }
      Mod+P              { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
      Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
      Mod+Ctrl+N         { move-column-to-workspace-down; }
      Mod+Ctrl+P         { move-column-to-workspace-up; }

      Mod+Shift+Page_Down { move-workspace-down; }
      Mod+Shift+Page_Up   { move-workspace-up; }
      Mod+Shift+N         { move-workspace-down; }
      Mod+Shift+P         { move-workspace-up; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+Ctrl+1 { move-column-to-workspace 1; }
      Mod+Ctrl+2 { move-column-to-workspace 2; }
      Mod+Ctrl+3 { move-column-to-workspace 3; }
      Mod+Ctrl+4 { move-column-to-workspace 4; }
      Mod+Ctrl+5 { move-column-to-workspace 5; }
      Mod+Ctrl+6 { move-column-to-workspace 6; }
      Mod+Ctrl+7 { move-column-to-workspace 7; }
      Mod+Ctrl+8 { move-column-to-workspace 8; }
      Mod+Ctrl+9 { move-column-to-workspace 9; }

      Mod+Tab { focus-workspace-previous; }

      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }

      Mod+Comma  { consume-window-into-column; }
      Mod+Period { expel-window-from-column; }

      Mod+R       { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-window-height; }
      Mod+Ctrl+R  { reset-window-height; }

      Mod+F       { maximize-column; }
      Mod+Ctrl+F  { expand-column-to-available-width; }
      Mod+Shift+F { fullscreen-window; }

      Mod+C       { center-column; }
      Mod+Ctrl+C  { center-visible-columns; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }

      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      Mod+V       { toggle-window-floating; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }

      Mod+W { toggle-column-tabbed-display; }

      Print      { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print  { screenshot-window; }
    }
  '';
}
