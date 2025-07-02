{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  cli'.neovim = {
    enable = true;
    withExtraPackages = true;
  };

  services' = {
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
