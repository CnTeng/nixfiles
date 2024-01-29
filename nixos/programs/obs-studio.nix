{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.obs;
in
{
  options.programs'.obs.enable = mkEnableOption "OBS Studio";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
      };
    };
  };
}
