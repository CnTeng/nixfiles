{ config, user, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common

    ../../modules/programs/onedrive.nix

    ../../modules/server/caddy.nix
    ../../modules/server/naive.nix
    ../../modules/server/vaultwarden.nix
    ../../modules/server/freshrss.nix
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
