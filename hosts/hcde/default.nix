{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  services' = {
    atuin.enable = true;
    authelia.enable = true;
    nixbuild.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    gitea.enable = true;
    ldap.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    postgresql.enable = true;
    restic.enable = true;
    trojan.server.enable = true;
    vaultwarden.enable = true;
  };
}
