{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.asciinema;
in
{
  options.development'.asciinema.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      programs.asciinema.enable = true;
      home.packages = [ pkgs.asciinema-agg ];
    };
  };
}
