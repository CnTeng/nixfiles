{ config, lib, ... }:
let
  cfg = config.programs'.aichat;
in
{
  options.programs'.aichat.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.aichat.enable = true;

    preservation'.user.directories = [ ".config/aichat" ];
  };
}
