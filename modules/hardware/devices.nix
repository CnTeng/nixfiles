{ config, lib, user, ... }:

with lib;

let
  cfg = config.custom.hardware.devices;
  inherit (cfg) components;
in {
  options.custom.hardware.devices = {
    enable = mkEnableOption "all devices support";
    components =
      mapAttrs (_: v: mkEnableOption (mkDoc v) // { default = cfg.enable; }) {
        audio = "audio support";
        light = "light support";
      };
  };

  config = mkIf cfg.enable (mkMerge [
    { users.users.${user}.extraGroups = [ "audio" "video" "camera" ]; }
    (mkIf components.audio {
      sound = {
        enable = true;
        mediaKeys.enable = true;
      };

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    })
    (mkIf components.light { programs.light.enable = true; })
  ]);
}