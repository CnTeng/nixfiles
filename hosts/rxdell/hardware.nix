{pkgs, ...}: {
  hardware' = {
    gpu.nvidia.enable = true;
    boot = {
      enable = true;
      secureboot = true;
    };
    cpu.intel.enable = true;
    stateless.enable = true;
    tlp.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "tpm"
        "tpm_tis"
        "tpm_crb"
      ];
      systemd.enable = true;
    };

    tmp.useTmpfs = true;
  };

  # Support for firmware update
  services.fwupd.enable = true;

  services.fstrim.enable = true;
}
