{
  imports = [ ./hardware.nix ];

  services' = {
    fail2ban.enable = true;
    tailscale.enable = true;
    trojan.enableServer = true;
  };
}
