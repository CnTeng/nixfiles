{ config, lib, user, ... }:

with lib;

let cfg = config.custom.services.openssh;
in {
  options.custom.services.openssh.enable = mkEnableOption "openssh";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 33 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
        GSSAPIAuthentication = false;
      };
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHhQjkubTtLVt8xkER41Zn4yYTTxEoBtFqbxBtbw6KxlAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
      ];
      root.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHhQjkubTtLVt8xkER41Zn4yYTTxEoBtFqbxBtbw6KxlAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
      ];
    };

    programs.ssh.startAgent = true;
  };
}
