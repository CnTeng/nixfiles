{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.anki;
in
{
  options.gui'.anki.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.anki ];

    preservation'.user.directories = [
      ".cache/Anki"
      ".local/share/Anki2"
    ];
  };
}
