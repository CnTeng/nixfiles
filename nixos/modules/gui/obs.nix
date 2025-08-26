{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.obs-studio;
in
{
  options.gui'.obs-studio.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
      # FIXME
      # enableVirtualCamera = true;
    };
  };
}
