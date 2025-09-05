{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.obs-studio;
in
{
  options.programs'.obs-studio.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
      enableVirtualCamera = true;
    };
  };
}
