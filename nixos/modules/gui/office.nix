{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.office;
in
{
  options.gui'.office.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    fonts.packages = [ pkgs.ttf-wps-fonts ];

    hm'.home.packages = [ pkgs.wpsoffice-cn ];

    preservation'.user.directories = [
      ".config/Kingsoft"
      ".local/share/Kingsoft"
    ];
  };
}
