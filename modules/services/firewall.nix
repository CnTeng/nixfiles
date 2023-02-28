{ config, lib, ... }:

with lib;

let cfg = config.custom.services.firewall;
in {
  options.custom.services.firewall.enable = mkEnableOption "firewall";

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
