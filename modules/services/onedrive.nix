{ config, lib, ... }:
with lib;
let cfg = config.services'.onedrive;
in {
  options.services'.onedrive.enable = mkEnableOption "OneDrive";

  config = mkIf cfg.enable { services.onedrive.enable = true; };
}
