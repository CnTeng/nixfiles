{ config, lib, ... }:
with lib;
let
  cfg = config.hardware'.optimise;
in
{
  options.hardware'.optimise.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    zramSwap.enable = true;

    services.fstrim.enable = true;
  };
}
