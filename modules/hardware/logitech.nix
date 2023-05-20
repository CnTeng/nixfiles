{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware'.logitech;
in {
  options.hardware'.logitech.enable = mkEnableOption "Logitech devices support";

  config = mkIf cfg.enable {
    services.ratbagd.enable = true;

    environment.systemPackages = [pkgs.piper];
  };
}
