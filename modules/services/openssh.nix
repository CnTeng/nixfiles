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
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMM41+K+kV5SHzktMpFw+Q/rpb0c73rVilhUjZPTdZy+AAAACXNzaDp5dWZlaQ== ssh:yufei"
    ];
    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMM41+K+kV5SHzktMpFw+Q/rpb0c73rVilhUjZPTdZy+AAAACXNzaDp5dWZlaQ== ssh:yufei"
    ];
  };
}
