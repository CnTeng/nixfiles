{
  imports = [./hardware.nix];

  basics'.system.stateVersion = "23.11";

  basics' = {
    locale.enable = false;
    security.enable = false;
  };

  services'.openssh.enable = true;
}
