{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.locker;
  inherit (config.desktop'.profiles) palette;
in {
  options.desktop'.profiles.locker = {
    enable = mkEnableOption "locker component";
    package =
      mkPackageOption pkgs "locker" {default = ["gtklock"];};
  };

  config = mkIf cfg.enable {
    security.pam.services.gtklock = {};

    home-manager.users.${user} = {
    };
  };
}
