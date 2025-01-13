{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.thunderbird;
in
{
  options.gui'.thunderbird.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".thunderbird"
        ".cache/thunderbird"
      ];
    };
  };
}
