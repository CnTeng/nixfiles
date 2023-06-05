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

  config = mkMerge [
    (mkIf cfg.enable {
      services.onedrive.enable = true;
    })

    (mkIf config.hardware'.stateless.enable {
      environment.persistence."/persist" = {
        users.${user}.directories = ["OneDrive"];
      };
    })
  ];
}
