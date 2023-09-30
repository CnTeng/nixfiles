{
  imports = [./disko.nix ./hardware.nix ./network.nix];

  services' = {
    authelia.port = 9091;
    caddy.enable = true;
    fail2ban.enable = true;
    firewall.enable = true;
    harmonia.port = 5222;
    hydra.port = 9222;
    miniflux.port = 6222;
    naive.enable = true;
    ntfy.port = 7222;
    openssh.enable = true;
    rsshub.port = 1200;
    vaultwarden.port = 8222;
  };
}
