{ config, lib, pkgs, ... }:
with lib;
let cfg = config.desktop'.profiles.wallpaper;
in {
  options.desktop'.profiles.wallpaper = {
    enable = mkEnableOption' { };
    image = mkOption {
      type = with types; nullOr path;
      visible = false;
    };
  };

  config = mkIf cfg.enable {
    desktop'.profiles.wallpaper.image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/l8/wallhaven-l8dgv2.jpg";
      sha256 = "sha256-dHTiXhzyju9yPVCixe7VMOG9T9FyQG/Hm79zhe0P4wk=";
    };
  };
}
