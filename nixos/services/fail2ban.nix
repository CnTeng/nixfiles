{ config, lib, ... }:
with lib;
let cfg = config.services'.fail2ban;
in {
  options.services'.fail2ban.enable = mkEnableOption' { };

  config = mkIf cfg.enable { services.fail2ban.enable = true; };
}
