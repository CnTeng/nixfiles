{ config, lib, user, ... }:

with lib;

let cfg = config.custom.programs.feh;
in {
  options.custom.programs.feh = { enable = mkEnableOption "feh"; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { programs.feh.enable = true; };
  };
}
