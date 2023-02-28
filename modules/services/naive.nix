{ config, lib, ... }:

with lib;

let cfg = config.custom.services.naive;
in {
  options.custom.services.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable { networking.firewall.allowedTCPPorts = [ 5222 ]; };
}
