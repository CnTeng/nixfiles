{ config, lib, ... }:
let
  cfg = config.programs'.opencode;
in
{
  options.programs'.opencode.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.opencode.enable = true;

    preservation'.user.directories = [
      ".cache/opencode"
      ".config/opencode"
      ".local/share/opencode"
    ];
  };
}
