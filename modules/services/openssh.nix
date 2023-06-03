{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.openssh;
  authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPmKxwF3v9GvcPJ67fNf42o5/NZvWqWkMu/QrRuQo95OAAAAD3NzaDpyeGF3c0BOaXhPUw== ssh:rxaws@NixOS"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFWwOxGhmGVpk2XUBu+PWPXeczcqA/PHt8P+EJrBull4AAAADnNzaDpyeGh6QE5peE9T ssh:rxhz@NixOS"
  ];
in {
  options.services'.openssh.enable = mkEnableOption "openssh";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [22];
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

    environment.persistence."/persist" =
      mkIf
      config.hardware'.impermanence.enable {
        files = [
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
  };
}
