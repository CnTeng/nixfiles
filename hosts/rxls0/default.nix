{
  imports = [./hardware.nix];

  services' = {
    fail2ban.enable = true;
    firewall.enable = true;
    naive.enable = true;
    openssh.enable = true;
  };
}
