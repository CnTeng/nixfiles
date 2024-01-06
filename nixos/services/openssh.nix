{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.services'.openssh;
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXYBwzvOg/23ZYFi8Jyw8Vr7thq16zrzI+/iLywTgwo ssh:deploy@NixOS"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIM2a/zgM9DYJSYU7WY6wFiOOTO53xGlllNm3TEoXsJDsAAAADnNzaDphdXRoQE5peE9T ssh:auth@NixOS"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOFNK1cWw9D1ES3Ae+IDC2Lm0SbsKykhLzJyhMJGLmEBAAAABHNzaDo= ssh:backup@NixOS"
  ];
in {
  options.services'.openssh.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keys = authorizedKeys;
      root.openssh.authorizedKeys.keys = authorizedKeys;
    };

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    security.sudo.extraConfig = ''
      Defaults env_keep+=SSH_AUTH_SOCK
    '';

    security.pam.services.sudo = { config, ... }: {
      rules.auth.rssh = {
        order = config.rules.auth.unix.order - 10;
        control = "sufficient";
        modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
        settings.auth_key_file = "/etc/ssh/authorized_keys.d/${user}";
      };
    };
  };
}
