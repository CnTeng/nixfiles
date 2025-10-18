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
    hm'.home.packages = [ pkgs.libreoffice-fresh ];

    preservation'.user.directories = [ ".config/libreoffice" ];
  };
}
