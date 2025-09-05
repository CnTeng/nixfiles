{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.spotify;
in
{
  options.programs'.spotify.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.spotify ];

    preservation'.user.directories = [
      ".cache/spotify"
      ".config/spotify"
    ];
  };
}
