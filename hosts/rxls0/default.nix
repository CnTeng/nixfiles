{
  imports = [ ./hardware.nix ];

  system.stateVersion = "23.11";

  services' = {
    fail2ban.enable = true;
    firewall.enable = true;
    naive-server.enable = true;
    openssh.enable = true;
  };
}
