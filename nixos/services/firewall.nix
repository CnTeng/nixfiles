{ config, lib, ... }:
with lib;
let cfg = config.services'.firewall;
in {
  options.services'.firewall.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 587 ];
    };
  };
}
