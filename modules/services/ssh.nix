{ user, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      UseDNS = false;
      GSSAPIAuthentication = "no";
    };
  };

  users.users = {
    ${user}.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
    ];
    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
    ];
  };

  programs.ssh.startAgent = true;
}
