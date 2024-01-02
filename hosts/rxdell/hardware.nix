{ pkgs, ... }: {
  hardware' = {
    systemd-boot.enable = true;
    secure-boot.enable = true;
    nvidia.enable = true;
    persist.enable = true;
    yubikey.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "usb_storage" "i915" ];
  };

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  zramSwap.enable = true;
}
