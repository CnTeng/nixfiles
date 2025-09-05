{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.calibre;
in
{
  options.programs'.calibre.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.calibre ];

    preservation'.user.directories = [
      ".cache/calibre"
      ".config/calibre"
    ];
  };
}
