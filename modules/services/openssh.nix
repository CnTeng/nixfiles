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
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAFcDV0fFdh2mcI/A1Q0/LRkD4gPjA1vIxtD33yEZbwbAAAABHNzaDo= rxtx@NixOS"
    ];
    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAFcDV0fFdh2mcI/A1Q0/LRkD4gPjA1vIxtD33yEZbwbAAAABHNzaDo= rxtx@NixOS"
    ];
  };
}
