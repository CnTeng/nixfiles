{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.sway;
in
{
  imports = [ ../profiles ];

  options.desktop'.sway.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        xdg-utils
        wl-clipboard
      ];
    };

    desktop'.profiles = {
      fonts.enable = true;
      idle.enable = true;
      inputMethod.enable = true;
      launcher.enable = true;
      login.enable = true;
      mako.enable = true;
      services.enable = true;
      theme.enable = true;
      utils.enable = true;
      variables.enable = true;
      waybar.enable = true;
      wireless.enable = true;
      xdg.enable = true;
    };

    home-manager.users.${user} =
      { config, ... }:
      {
        wayland.windowManager.sway = {
          enable = true;
          wrapperFeatures.gtk = true;
          config = {
            fonts = {
              names = [
                "RobotoMono Nerd Font"
                "Sarasa UI SC"
              ];
              size = 10.0;
            };
            window = {
              titlebar = false;
              border = 3;
            };
            floating.border = 3;
            assigns = { };
            workspaceAutoBackAndForth = true;
            modifier = "Mod4";
            colors = { };
            bars = [ ];
            startup = [
              {
                command = getExe pkgs.autotiling;
                always = true;
              }
            ];
            gaps = {
              inner = 3;
              outer = 3;
            };
            terminal = getExe pkgs.kitty;
            keybindings =
              let
                inherit (config.wayland.windowManager.sway.config) modifier menu;

                swayosd = getExe' pkgs.swayosd "swayosd-client";
                grimshot = getExe pkgs.sway-contrib.grimshot;
                nautilus = getExe' pkgs.gnome.nautilus "nautilus";
                playerctl = getExe pkgs.playerctl;
              in
              lib.mkOptionDefault {
                "${modifier}+Shift+q" = "null";
                "${modifier}+q" = "kill";
                "${modifier}+p" = "exec ${getExe pkgs.hyprpicker} -a";
                "${modifier}+d" = "null";
                "${modifier}+e" = "exec ${nautilus}";
                "${modifier}+space" = "exec ${menu}";
                "${modifier}+Escape" = "mode exit";

                Print = "exec ${grimshot} --notify savecopy window";

                XF86MonBrightnessUP = "exec ${swayosd} --brightness raise";
                XF86MonBrightnessDown = "exec ${swayosd} --brightness lower";

                XF86AudioNext = "exec ${playerctl} next";
                XF86AudioPrev = "exec ${playerctl} previous";
                XF86AudioPlay = "exec ${playerctl} play-pause";
                XF86AudioStop = "exec ${playerctl} stop";
                XF86AudioRaiseVolume = "exec ${swayosd} --output-volume raise";
                XF86AudioLowerVolume = "exec ${swayosd} --output-volume lower";
                XF86AudioMute = "exec ${swayosd} --output-volume mute-toggle";
                XF86AudioMicMute = "exec ${swayosd} --iuput-volume mute-toggle";
              };
            input = {
              "type:touchpad" = {
                natural_scroll = "enabled";
                tap = "enabled";
              };
              "type:keyboard" = {
                xkb_options = "ctrl:nocaps";
                repeat_delay = "300";
                repeat_rate = "50";
              };
            };
            output =
              let
                image = pkgs.fetchurl {
                  url = "https://w.wallhaven.cc/full/l8/wallhaven-l8dgv2.jpg";
                  sha256 = "sha256-dHTiXhzyju9yPVCixe7VMOG9T9FyQG/Hm79zhe0P4wk=";
                };
              in
              {
                "*".bg = "${image} fill";
                eDP-1.scale = "1.5";
                "Dell Inc. DELL U2518D 3M7K8013ARCL".scale = "1.25";
                "Dell Inc. DELL U2723QX 843R0P3".scale = "1.75";
              };
            workspaceOutputAssign = [
              {
                workspace = "1";
                output = "eDP-1";
              }
            ];
            modes.exit = {
              l = "exec loginctl lock-session; mode default";
              q = "exec systemctl --user stop sway-session.target; loginctl terminate-session $XDG_SESSION_ID";
              s = "exec systemctl poweroff";
              r = "exec systemctl reboot";
              "Escape" = "mode default";
            };
          };
        };
      };
  };
}
