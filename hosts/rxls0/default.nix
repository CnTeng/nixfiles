{
  imports = [./hardware.nix];

  services' = {
    caddy.enable = true;
    fail2ban.enable = true;
    firewall.enable = true;
    naive.enable = true;
    openssh.enable = true;
  };
}
