{ config, lib, ... }:
with lib;
let cfg = config.services'.firewall;
in {
  options.services'.firewall.enable = mkEnableOption "firewall";

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 587 ];
    };
  };
}
