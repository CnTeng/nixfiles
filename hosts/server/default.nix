{ config, user, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/programs/onedrive.nix

    ../../modules/services/caddy.nix
    ../../modules/services/naive.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/calibre.nix
    ../../modules/services/freshrss.nix
  ];

  services.openssh = {
    enable = true;
    ports = [ 23 ];
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  networking = {
    hostName = "rxtx";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  users.users = {
    ${user}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/Y4kiqZIPYgYLvwNPe7Vx09ix6dSxnzaV6Awn7Lm+D rxtx@nixos"
    ];
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/Y4kiqZIPYgYLvwNPe7Vx09ix6dSxnzaV6Awn7Lm+D rxtx@nixos"
    ];
  };
}
