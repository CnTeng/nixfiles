{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.obs;
in
{
  options.programs'.obs.enable = lib.mkEnableOption "OBS Studio";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/obs-studio" ];
    };
  };
}
