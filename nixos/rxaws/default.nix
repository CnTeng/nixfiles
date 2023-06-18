{
  imports = [ ./hardware.nix ];

  basics'.ssh.enable = false;

  services' = {
    caddy.enable = true;
    firewall.enable = true;
    naive.enable = true;
    openssh.enable = true;
  };

  shell'.proxy.enable = false;
}
