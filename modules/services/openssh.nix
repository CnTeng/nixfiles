{ user, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 23 ];
    passwordAuthentication = true;
    permitRootLogin = "yes";
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
