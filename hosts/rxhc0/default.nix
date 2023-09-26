{
  imports = [./disko.nix ./hardware.nix ./network.nix];

  services' = {
    authelia.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    firewall.enable = true;
    harmonia.enable = true;
    hydra.enable = true;
    miniflux.enable = true;
    naive.enable = true;
    ntfy.enable = true;
    openssh.enable = true;
    rsshub.enable = true;
    vaultwarden.enable = true;
  };
}
