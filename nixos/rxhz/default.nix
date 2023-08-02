{
  imports = [./hardware.nix ./networking.nix ./disko.nix];

  services' = {
    cache.enable = false;
    caddy.enable = true;
    calibre-web.enable = true;
    firewall.enable = true;
    hydra.enable = true;
    miniflux.enable = true;
    naive.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
  };
}
