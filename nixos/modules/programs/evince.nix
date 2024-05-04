{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.programs'.evince;
in
{
  options.programs'.evince.enable = lib.mkEnableOption "Evince";

  config = lib.mkIf cfg.enable {
    programs.evince.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/evince" ];
    };
  };
}
