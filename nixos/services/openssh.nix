{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.openssh;
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXYBwzvOg/23ZYFi8Jyw8Vr7thq16zrzI+/iLywTgwo ssh:deploy@NixOS"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIM2a/zgM9DYJSYU7WY6wFiOOTO53xGlllNm3TEoXsJDsAAAADnNzaDphdXRoQE5peE9T ssh:auth@NixOS"
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

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
