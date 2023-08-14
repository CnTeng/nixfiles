{
  imports = [./hardware.nix];

  services' = {
    caddy.enable = true;
    firewall.enable = true;
    naive.enable = true;
    openssh.enable = true;
  };
}
