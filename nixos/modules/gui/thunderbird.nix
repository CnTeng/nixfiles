{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.thunderbird;
in
{
  options.gui'.thunderbird.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    programs.thunderbird.enable = true;

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".thunderbird"
        ".cache/thunderbird"
      ];
    };
  };
}
