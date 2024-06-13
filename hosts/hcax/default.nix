{
  imports = [ ./hardware.nix ];

  services' = {
    atuin.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    restic.enable = true;
    syncthing.server.enable = true;
    tuic.server.enable = true;
    vaultwarden.enable = true;
  };
}
