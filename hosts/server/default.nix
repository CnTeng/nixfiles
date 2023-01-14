{ ... }:

{
  networking.hostName = "rxtx";

  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/programs/onedrive.nix

    ../../modules/services/ssh.nix
    ../../modules/services/firewall.nix
    ../../modules/services/caddy.nix
    ../../modules/services/naive.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/calibre.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/memos.nix
  ];
}
