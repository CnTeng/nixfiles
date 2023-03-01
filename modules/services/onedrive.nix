{ config, lib, ... }:

with lib;

let cfg = config.custom.services.onedrive;
in {
  options.custom.services.onedrive.enable = mkEnableOption "OneDrive";

  config = mkIf cfg.enable { services.onedrive.enable = true; };
}
