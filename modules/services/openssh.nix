{ config, lib, user, ... }:

with lib;

let cfg = config.custom.services.openssh;
in {
  options.custom.services.openssh.enable = mkEnableOption "openssh";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
        GSSAPIAuthentication = false;
      };
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHhQjkubTtLVt8xkER41Zn4yYTTxEoBtFqbxBtbw6KxlAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILz6VT0DM51kUB5BQOr2IcUKKNtd40I3FMNEgHpRAvBCAAAADnNzaDpyeGh6QE5peE9T ssh:rxhz@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgYNuR3TCv/wZw9GqPx/TK3q4K9lotfdRTCsgNh/OS5 root@rxhz"
      ];
      root.openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHhQjkubTtLVt8xkER41Zn4yYTTxEoBtFqbxBtbw6KxlAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILz6VT0DM51kUB5BQOr2IcUKKNtd40I3FMNEgHpRAvBCAAAADnNzaDpyeGh6QE5peE9T ssh:rxhz@NixOS"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJsesttoCaugSKmHFIORINbEhvvqa7IhKO4viq3WLYktAAAADnNzaDpyeHR4QE5peE9T ssh:rxtx@NixOS"
      ];
    };

    programs.ssh.startAgent = true;
  };
}
