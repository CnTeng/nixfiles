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

    environment.persistence."/persist" = mkIf config.hardware'.stateless.enable {
      files = ["/etc/vmware/license-ws-170-e5-202208"];
      users.${user}.directories = [".vmware"];
    };
  };
}
