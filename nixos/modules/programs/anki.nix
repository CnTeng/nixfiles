{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.anki;
in
{
  options.programs'.anki.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.anki ];

    preservation'.user.directories = [
      ".cache/Anki"
      ".local/share/Anki2"
    ];
  };
}
