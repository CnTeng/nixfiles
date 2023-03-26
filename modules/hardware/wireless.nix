{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.custom.hardware.wireless;
  inherit (cfg) components;
in {
  options.custom.hardware.wireless = {
    enable = mkEnableOption "wireless support";
    components = mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // { default = cfg.enable; }) {
        network = "network support";
        bluetooth = "Bluetooth support";
      };
  };

  config = mkMerge [
    (mkIf components.network {
      users.users.${user}.extraGroups = [ "networkmanager" ];
      networking.networkmanager.enable = true;
    })
    (mkIf components.bluetooth {
      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluezFull;
      };
      services.blueman.enable = true;
    })
  ];
}
