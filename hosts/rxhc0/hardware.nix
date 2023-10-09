{modulesPath, ...}: {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  hardware' = {
    persist.enable = true;
    boot.enable = true;
  };

  boot.initrd = {
    availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
    kernelModules = ["nvme"];
  };

  boot.tmp.useTmpfs = true;

  zramSwap.enable = true;
}
