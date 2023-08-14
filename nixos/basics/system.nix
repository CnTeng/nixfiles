{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.basics'.system;
in {
  options.basics'.system.stateVersion = mkOption {
    type = types.str;
    default = config.system.nixos.release;
  };

  config.system.stateVersion = cfg.stateVersion;
}
