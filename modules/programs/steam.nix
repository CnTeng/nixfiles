{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.steam;
in {
  options.programs'.steam.enable = mkEnableOption "Steam";

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    home-manager.users.${user} = { home.packages = [ pkgs.protonup-ng ]; };
  };
}
