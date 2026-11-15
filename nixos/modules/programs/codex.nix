{ config, lib, ... }:
let
  cfg = config.programs'.codex;
in
{
  options.programs'.codex.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.codex.enable = true;

    preservation'.user.directories = [ ".config/codex" ];
  };
}
