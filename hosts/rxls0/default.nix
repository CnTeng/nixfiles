{
  imports = [ ./hardware.nix ];

  basics'.system.stateVersion = "23.11";

  services' = {
    fail2ban.enable = true;
    firewall.enable = true;
    naive.enable = true;
    openssh.enable = true;
  };
}
