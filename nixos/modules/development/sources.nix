{ config, lib, ... }:
let
  cfg = config.development'.sources;
in
{
  options.development'.sources.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    preservation'.user.directories = [ "Sources" ];
  };
}
