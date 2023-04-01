{ config, lib, user, ... }:
with lib;
let cfg = config.programs'.feh;
in {
  options.programs'.feh.enable = mkEnableOption "feh";

  config = mkIf cfg.enable {
    home-manager.users.${user} = { programs.feh.enable = true; };
  };
}
