{
  modulesPath,
  lib,
  ...
}: {
  imports = ["${modulesPath}/virtualisation/amazon-image.nix"];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  hardware'.kernel.modules.bbr = true;
}
