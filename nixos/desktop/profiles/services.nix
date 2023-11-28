{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.services;
in {
  options.desktop'.profiles.services.enable =
    mkEnableOption "services component";

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.upower.enable = true;
    services.dbus.implementation = "broker";
    services.gvfs.enable = true;

    # power
    services.tlp.enable = true;
    services.thermald.enable = true;

    home-manager.users.${user} = {
      home.packages = [pkgs.wl-clipboard];

      services.udiskie.enable = true;
      services.clipman.enable = true;

      services.kanshi = let
        hyprctl = getExe' pkgs.hyprland "hyprctl";
      in {
        enable = true;
        profiles = {
          undocked.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.25;
            }
          ];
          docked-work = {
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.25;
              }
              {
                criteria = "Dell Inc. DELL U2518D 3M7K8013ARCL";
                position = "1536,0";
                scale = 1.25;
              }
            ];
            exec = [
              "${hyprctl} dispatch workspace 2"
              "${hyprctl} dispatch moveworkspacetomonitor 2 1"
            ];
          };

          docked-home = {
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.25;
              }
              {
                criteria = "Dell Inc. DELL U2723QX 843R0P3";
                position = "1536,0";
                scale = 1.75;
              }
            ];
            exec = [
              "${hyprctl} dispatch workspace 2"
              "${hyprctl} dispatch moveworkspacetomonitor 2 1"
            ];
          };
        };
        systemdTarget = "graphical-session.target";
      };
    };
  };
}
