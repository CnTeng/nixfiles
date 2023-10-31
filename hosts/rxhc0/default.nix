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
    ntfy.port = 7222;
    openssh.enable = true;
    vaultwarden.port = 8222;
    restic.enable = true;
  };
}
