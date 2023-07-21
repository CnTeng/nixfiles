{
  imports = [./hardware.nix ./networking.nix ./disko.nix];

  basics'.ssh.enable = false;

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

  shell'.proxy.enable = false;
}
