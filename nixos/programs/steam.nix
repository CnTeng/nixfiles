{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.steam;
in
{
  options.programs'.steam.enable = mkEnableOption "Steam";

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".local/share/Steam" ];
    };
  };
}
