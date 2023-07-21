{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.hardware'.razer;
in {
  options.hardware'.razer.enable = mkEnableOption "Razer devices support";

  config = mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = [user];
    };
  };
}
