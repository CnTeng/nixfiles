{modulesPath, ...}: {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  hardware'.kernel.modules.bbr = true;

  boot = {
    loader.grub.device = "/dev/sda";

    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    cleanTmpDir = true;
  };

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  zramSwap.enable = true;
}
