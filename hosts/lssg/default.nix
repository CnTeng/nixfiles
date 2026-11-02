{
  imports = [ ./hardware.nix ];

  development'.neovim.enable = true;

  services' = {
    fail2ban.enable = true;
    sing-box.server.enable = true;
    tailscale.enable = true;
  };
}
