{ config, lib, user, ... }:

with lib;

let
  cfg = config.custom.services.openssh;
  authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPmKxwF3v9GvcPJ67fNf42o5/NZvWqWkMu/QrRuQo95OAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFWwOxGhmGVpk2XUBu+PWPXeczcqA/PHt8P+EJrBull4AAAADnNzaDpyeGh6QE5peE9T ssh:rxhz@NixOS"
  ];
in {
  options.custom.services.openssh.enable = mkEnableOption "openssh";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = mkDefault "yes";
        GSSAPIAuthentication = false;
      };
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keys = authorizedKeys;
      root.openssh.authorizedKeys.keys = authorizedKeys;
    };

    programs.ssh.startAgent = true;
  };
}
