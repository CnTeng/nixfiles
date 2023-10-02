{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.locker;
in {
  options.desktop'.profiles.locker = {
    enable = mkEnableOption "locker component";
    package =
      mkPackageOption pkgs "locker" {default = ["gtklock"];};
  };

  config = mkIf cfg.enable {
    security.pam.services.gtklock = {};
  };
}
