{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.office;
in
{
  options.programs'.office.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    fonts.packages = [ pkgs.ttf-wps-fonts ];

    hm'.home.packages = [ pkgs.wpsoffice-cn ];

    preservation'.user.directories = [
      ".config/Kingsoft"
      ".local/share/Kingsoft"
    ];
  };
}
