{
  imports = [ ./disko.nix ./hardware.nix ];

  system.stateVersion = "23.11";

  services' = {
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
