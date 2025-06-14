{
  config,
  lib,
  ...
}:
let
  cfg = config.cli'.npm;
in
{
  options.cli'.npm.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    programs.npm = {
      enable = true;
      npmrc = ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
        logs-dir=''${XDG_STATE_HOME}/npm/logs
      '';
    };
  };
}
