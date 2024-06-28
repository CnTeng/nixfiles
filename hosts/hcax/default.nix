{
  imports = [ ./hardware.nix ];

  services' = {
    atuin.enable = true;
    authelia.enable = true;
    nixbuild.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    ldap.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    restic.enable = true;
    syncthing.enable = true;
    tuic.server.enable = true;
    vaultwarden.enable = true;
  };
}
