{ config, lib, ... }:
let
  cfg = config.services'.postgresql;
in
{
  options.services'.postgresql.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable { services.postgresql.enable = true; };
}
