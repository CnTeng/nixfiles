{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.evince;
in
{
  options.programs'.evince.enable = mkEnableOption "Evince";

  config = mkIf cfg.enable {
    programs.evince.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/evince" ];
    };
  };
}
