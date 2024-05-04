{ config, lib, ... }:
let
  cfg = config.desktop'.profiles.utils;
in
{
  options.desktop'.profiles.utils.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable { programs.file-roller.enable = true; };
}
