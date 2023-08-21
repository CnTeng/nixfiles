{
  imports = [./hardware.nix ./networking.nix ./disko.nix];

  services' = {
    cache.enable = false;
    caddy.enable = true;
    calibre-web.enable = false;
    firewall.enable = true;
    hydra.enable = false;
    miniflux.enable = true;
    naive.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
  };
}
