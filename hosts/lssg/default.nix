{
  imports = [ ./hardware.nix ];

  services' = {
    fail2ban.enable = true;
    tuic.server.enable = true;
  };
}
