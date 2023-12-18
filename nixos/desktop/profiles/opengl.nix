{ config, lib, pkgs, ... }:
with lib;
let cfg = config.desktop'.profiles.opengl;
in {
  options.desktop'.profiles.opengl.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    hardware.opengl.extraPackages = with pkgs; [ intel-media-driver ];

    environment.systemPackages = with pkgs; [
      pciutils
      libva-utils
      intel-gpu-tools
    ];
  };
}
