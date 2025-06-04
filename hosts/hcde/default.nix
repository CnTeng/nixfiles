{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  cli'.neovim.enable = true;

  services' = {
    anki-sync.enable = true;
    atuin.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    pocket-id.enable = true;
    postgresql.enable = true;
    privatebin.enable = true;
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableServer = true;
    vaultwarden.enable = true;
    webdav.enable = true;
  };
}
