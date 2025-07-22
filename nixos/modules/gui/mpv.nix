{ config, lib, ... }:
let
  cfg = config.gui'.mpv;
in
{
  options.gui'.mpv.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.mpv.enable = true;
  };
}
