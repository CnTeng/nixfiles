{ config, lib, ... }:
let
  cfg = config.cli'.aichat;
in
{
  options.cli'.aichat.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.aichat.enable = true;

    preservation'.user.directories = [ ".config/aichat" ];
  };
}
