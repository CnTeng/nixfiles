{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware'.tlp;
in {
  options.hardware'.tlp.enable =
    mkEnableOption "tlp support";

  config = mkIf cfg.enable {
    services = {
      tlp.enable = true;
      thermald.enable = true;
    };
  };
}
