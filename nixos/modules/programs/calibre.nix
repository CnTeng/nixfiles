{ config, lib, ... }:
let
  cfg = config.programs'.calibre;
in
{
  options.programs'.calibre.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.calibre.enable = true;

    preservation'.user.directories = [
      ".cache/calibre"
      ".config/calibre"
    ];
  };
}
