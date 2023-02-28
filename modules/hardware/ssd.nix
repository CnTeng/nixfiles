{ config, lib, ... }:

with lib;

let cfg = config.custom.hardware.ssd;
in {
  options.custom.hardware.ssd = { enable = mkEnableOption "ssd support"; };

  config = mkIf cfg.enable { services.fstrim.enable = true; };
}
