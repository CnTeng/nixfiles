{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.utils;
in
{
  options.desktop'.profiles.utils.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    programs.file-roller.enable = true;

    users.users.${user}.extraGroups = [ "video" ];
    hardware.brillo.enable = true;
  };
}
