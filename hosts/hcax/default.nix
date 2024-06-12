{
  imports = [ ./hardware.nix ];

  services' = {
    atuin.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    vaultwarden.enable = true;
    restic.enable = true;
    tuic.server.enable = true;
  };
}
