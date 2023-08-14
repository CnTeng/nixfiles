{
  imports = [./hardware.nix ./networking.nix ./disko.nix];

  services' = {
    cache.enable = false;
    caddy.enable = false;
    calibre-web.enable = false;
    firewall.enable = true;
    hydra.enable = false;
    miniflux.enable = false;
    naive.enable = false;
    openssh.enable = true;
    vaultwarden.enable = false;
  };
  documentation.man.generateCaches = false;
}
