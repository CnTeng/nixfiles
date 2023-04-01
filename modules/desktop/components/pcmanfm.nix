{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.desktop'.components.pcmanfm;
in {
  options.desktop'.components.pcmanfm.enable = mkEnableOption "pcmanfm";

  config = mkIf cfg.enable {
    services = {
      # Enable trash can for pcmanfm
      gvfs.enable = true;

      # Enable USB Automounting
      udisks2.enable = true;
      devmon.enable = true;
    };

    home-manager.users.${user} = {
      home.packages = [ pkgs.pcmanfm ];
      services.udiskie.enable = true;
    };
  };
}
