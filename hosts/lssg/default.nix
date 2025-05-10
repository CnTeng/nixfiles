{
  imports = [ ./hardware.nix ];

  cli'.neovim.enable = true;

  services' = {
    fail2ban.enable = true;
    tailscale.enable = true;
    trojan.enableServer = true;
  };
}
