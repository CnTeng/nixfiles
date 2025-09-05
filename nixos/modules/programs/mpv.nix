{ config, lib, ... }:
let
  cfg = config.programs'.mpv;
in
{
  options.programs'.mpv.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.mpv.enable = true;
  };
}
