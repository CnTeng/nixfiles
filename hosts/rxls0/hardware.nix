{ modulesPath, lib, ... }:
{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  hardware' = {
    network.enable = true;
    optimise.enable = true;
  };

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
