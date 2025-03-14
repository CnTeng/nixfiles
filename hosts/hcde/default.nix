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
    kavita.enable = true;
    ldap.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    postgresql.enable = true;
    privatebin.enable = true;
    restic.enable = true;
    trojan.enableServer = true;
    vaultwarden.enable = true;
  };
}
