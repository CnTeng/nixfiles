{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  development' = {
    neovim = {
      enable = true;
      withExtraPackages = true;
    };
    podman.enable = true;
    qemu.enable = true;
  };

  services' = {
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
