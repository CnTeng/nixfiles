{
  imports = [ ./hardware.nix ];

  system.stateVersion = "23.11";

  services' = {
    fail2ban.enable = true;
    tuic.server.enable = true;
  };
}
