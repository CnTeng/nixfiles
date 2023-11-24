{
  imports = [./disko.nix ./hardware.nix ./network.nix];

  services' = {
    authelia.enable = true;
    caddy.enable = true;
    fail2ban.enable = true;
    firewall.enable = true;
    miniflux.enable = true;
    ntfy.enable = true;
    openssh.enable = true;
    vaultwarden.enable = true;
    restic.enable = true;
  };
}
