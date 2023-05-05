{
  imports = [./hardware.nix ./networking.nix];

  basics'.ssh.enable = false;

  services' = {
    cache.enable = true;
    caddy.enable = true;
    calibre-web.enable = true;
    firewall.enable = true;
    hydra.enable = true;
    miniflux.enable = true;
    naive.enable = true;
    onedrive.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
  };

  shell' = {
    proxy.enable = false;
    neovim.withNixTreesitter = false;
  };
}
