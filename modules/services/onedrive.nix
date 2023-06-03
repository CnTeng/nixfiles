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

    environment.persistence."/persist" = {
      users.${user} = {
        directories = ["OneDrive"];
      };
    };
  };
}
