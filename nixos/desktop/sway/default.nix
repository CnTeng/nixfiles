{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.sway;
  inherit (config.core'.colors) palette;
  inherit (config.desktop'.profiles.wallpaper) image;
in {
  imports = [ ../profiles ];

  options.desktop'.sway.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    desktop'.profiles = {
      console.enable = true;
      fonts.enable = true;
      idle.enable = true;
      inputMethod.enable = true;
      launcher.enable = true;
      login.enable = true;
      mako.enable = true;
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

    home-manager.users.${user} = { config, ... }: {
      wayland.windowManager.sway = {
        enable = true;
        systemd.xdgAutostart = true;
        wrapperFeatures.gtk = true;
        extraOptions = [ "--unsupported-gpu" ];
        config = {
          fonts = {
            names = [ "RobotoMono Nerd Font" "Sarasa UI SC" ];
            size = 11.0;
          };
          window = {
            titlebar = false;
            border = 3;
          };
          floating.border = 3;
          assigns = { };
          workspaceAutoBackAndForth = true;
          modifier = "Mod4";
          colors = {
            focused = {
              border = palette.text.hex;
              background = palette.base.hex;
              text = palette.text.hex;
              indicator = palette.blue.hex;
              childBorder = palette.text.hex;
            };
          };
          bars = [ ];
          startup = [{
            command = getExe pkgs.autotiling;
            always = true;
          }];
          gaps = {
            inner = 3;
            outer = 3;
            smartGaps = true;
          };
          terminal = getExe pkgs.kitty;
          keybindings = let
            inherit (config.wayland.windowManager.sway.config) modifier menu;

            grimblast = getExe pkgs.grimblast;
            nautilus = getExe' pkgs.gnome.nautilus "nautilus";
            brillo = getExe pkgs.brillo;
            playerctl = getExe pkgs.playerctl;
            pamixer = getExe pkgs.pamixer;

          in lib.mkOptionDefault {
            "${modifier}+Shift+q" = "null";
            "${modifier}+q" = "kill";
            "${modifier}+d" = "null";
            "${modifier}+e" = "exec ${nautilus}";
            "${modifier}+space" = "exec ${menu}";
            "${modifier}+Escape" = "mode exit";

            Print = "exec ${grimblast} --notify --freeze copysave area";

            XF86MonBrightnessUP = "exec ${brillo} -u 300000 -A 5";
            XF86MonBrightnessDown = "exec ${brillo} -u 300000 -U 5";

            XF86AudioNext = "exec ${playerctl} next";
            XF86AudioPrev = "exec ${playerctl} previous";
            XF86AudioPlay = "exec ${playerctl} play-pause";
            XF86AudioStop = "exec ${playerctl} stop";
            XF86AudioRaiseVolume = "exec ${pamixer} -i 10";
            XF86AudioLowerVolume = "exec ${pamixer} -d 10";
            XF86AudioMute = "exec ${pamixer} -t";
          };
          input = {
            "type:touchpad" = {
              natural_scroll = "enabled";
              tap = "enabled";
            };
            "type:keyboard".xkb_options = "ctrl:nocaps";
          };
          output = {
            "*".bg = "${image} fill";
            eDP-1.scale = "1.25";
            "Dell Inc. DELL U2518D 3M7K8013ARCL".scale = "1.25";
            "Dell Inc. DELL U2723QX 843R0P3".scale = "1.75";
          };
          modes.exit = {
            l = "exec loginctl lock-session; mode default";
            q =
              "exec systemctl --user stop sway-session.target; loginctl terminate-session $XDG_SESSION_ID";
            s = "exec systemctl poweroff";
            r = "exec systemctl reboot";
            "Escape" = "mode default";
          };
        };
      };
    };
  };
}
