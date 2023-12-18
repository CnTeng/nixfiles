{ modulesPath, ... }: {
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware'.persist.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    kernelModules = [ "nvme" ];
  };

  zramSwap.enable = true;

}
