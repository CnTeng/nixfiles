{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.thunderbird;
in
{
  options.programs'.thunderbird.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
    };

    preservation'.user.directories = [
      ".thunderbird"
      ".cache/thunderbird"
    ];
  };
}
