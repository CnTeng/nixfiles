{
  imports = [./hardware.nix ./networking.nix ./disko.nix];

  services' = {
    caddy.enable = true;
    calibre-web.enable = false;
    fail2ban.enable = true;
    firewall.enable = true;
    harmonia.enable = false;
    hydra.enable = false;
    miniflux.enable = true;
    naive.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
  };
}
