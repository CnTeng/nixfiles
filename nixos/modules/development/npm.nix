{ config, lib, ... }:
let
  cfg = config.development'.npm;
in
{
  options.development'.npm.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.npm = {
      enable = true;
      settings = {
        prefix = "\${XDG_DATA_HOME}/npm";
        cache = "\${XDG_CACHE_HOME}/npm";
        init-module = "\${XDG_CONFIG_HOME}/npm/config/npm-init.js";
        logs-dir = "\${XDG_STATE_HOME}/npm/logs";
      };
    };

    preservation'.user.directories = [
      ".local/state/npm"
      ".cache/npm"
    ];
  };
}
