{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.onedrive;
in {
  options.services'.onedrive.enable = mkEnableOption "OneDrive";

  config = mkIf cfg.enable {
    services.onedrive.enable = true;

    systemd.user.services.onedrive-launcher = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = mkForce ["graphical-session.target"]; # enable notifications
    };

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = ["OneDrive"];
    };
  };
}
