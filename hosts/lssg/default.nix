{
  imports = [ ./hardware.nix ];

  services' = {
    fail2ban.enable = true;
    hysteria2.enableServer = true;
  };
}
