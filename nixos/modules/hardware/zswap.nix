{
  config,
  lib,
  ...
}:
let
  cfg = config.hardware'.zswap;
in
{
  options.hardware'.zswap.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    boot.kernel.sysfs = {
      module.zswap.parameters.enabled = true;
    };
  };
}
