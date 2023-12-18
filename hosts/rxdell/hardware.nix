{ pkgs, ... }: {
  hardware' = {
    secureboot.enable = true;
    nvidia.enable = true;
    persist.enable = true;
    yubikey.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "i915" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.intel.updateMicrocode = true;

  # Support for firmware update
  services.fwupd.enable = true;

  services.fstrim.enable = true;
}
