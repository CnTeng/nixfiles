{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.steam;
in {
  options.custom.programs.steam = { enable = mkEnableOption "Steam"; };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    home-manager.users.${user} = { home.packages = [ pkgs.protonup-ng ]; };
  };
}
