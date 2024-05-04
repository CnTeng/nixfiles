{ config, lib, ... }:
let
  cfg = config.services'.fail2ban;
in
{
  options.services'.fail2ban.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable { services.fail2ban.enable = true; };
}
