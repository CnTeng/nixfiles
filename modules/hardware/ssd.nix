{ config, lib, ... }:
with lib;
let cfg = config.hardware'.ssd;
in {
  options.hardware'.ssd.enable = mkEnableOption "SSD support";

  config = mkIf cfg.enable { services.fstrim.enable = true; };
}
