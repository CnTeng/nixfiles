{ config, lib, user, ... }:

with lib;

let cfg = config.custom.programs.kdeconnect;
in {
  options.custom.programs.kdeconnect = {
    enable = mkEnableOption "kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;

    home-manager.users.${user} = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
