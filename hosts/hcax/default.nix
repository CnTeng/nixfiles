{
  imports = [ ./hardware.nix ];

  system.stateVersion = "23.11";

  services' = {
    caddy.enable = true;
    # calibre.enable = true;
    fail2ban.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    # onedrive.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
    restic.enable = true;
    tuic.server.enable = true;
  };

  utils'.neovim.enable = false;
}
