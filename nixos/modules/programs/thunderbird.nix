{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.thunderbird;
in
{
  options.programs'.thunderbird.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-128;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".thunderbird"
        ".cache/thunderbird"
      ];
    };
  };
}
