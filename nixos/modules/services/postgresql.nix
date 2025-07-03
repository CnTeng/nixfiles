{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.postgresql;
in
{
  options.services'.postgresql.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/postgresql" ];
    };
  };
}
