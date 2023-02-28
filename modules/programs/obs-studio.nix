{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.obs;
in {
  options.custom.programs.obs = { enable = mkEnableOption "obs-studio"; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
      };
    };
  };
}
