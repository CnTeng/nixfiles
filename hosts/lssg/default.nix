{
  imports = [ ./hardware.nix ];

  services' = {
    fail2ban.enable = true;
    trojan.enableServer = true;
  };
}
