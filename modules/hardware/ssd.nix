{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware'.ssd;
in {
  options.hardware'.ssd.enable = mkEnableOption "ssd support";

  config = mkIf cfg.enable {services.fstrim.enable = true;};
}
