{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ../../modules/hardware
  ];

  custom.hardware.kernel.modules.bbr = true;

  boot = {
    loader.grub.device = "/dev/vda";

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
      ];
      kernelModules = [ "nvme" ];
    };

    cleanTmpDir = true;
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  zramSwap.enable = true;
}
