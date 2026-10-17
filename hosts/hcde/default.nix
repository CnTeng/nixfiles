{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  development'.neovim.enable = true;

  services' = {
    anki-sync.enable = true;
    atuin.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    miniflux.enable = true;
    niks3.enable = true;
    outline.enable = true;
    pocket-id.enable = true;
    postgresql.enable = true;
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableServer = true;
    vaultwarden.enable = true;
    webdav.enable = true;
  };
}
