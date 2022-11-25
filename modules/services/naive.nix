{ pkgs, config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5222 ];
}
