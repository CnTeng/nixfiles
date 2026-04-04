{ config, lib, ... }:
let
  cfg = config.programs'.agent;
in
{
  options.programs'.agent.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      programs.codex.enable = true;
      programs.opencode.enable = true;
    };

    preservation'.user.directories = [
      ".config/codex"

      ".cache/opencode"
      ".config/opencode"
      ".local/share/opencode"
    ];
  };
}
