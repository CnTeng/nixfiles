{
  imports = [ ./hardware.nix ];

  development'.neovim.enable = true;

  services' = {
    fail2ban.enable = true;
    tailscale.enable = true;
    trojan.enableServer = true;
  };
}
