{pkgs, ...}: {
  hardware' = {
    boot = {
      enable = true;
      secureboot = true;
    };
    cpu.enable = true;
    nvidia.enable = true;
    persist.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  boot.initrd.systemd = {
    enable = true;
    enableTpm2 = true;
  };

  boot.tmp.useTmpfs = true;

  # Support for firmware update
  services.fwupd.enable = true;

  services.fstrim.enable = true;
}
