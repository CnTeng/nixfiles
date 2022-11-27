{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # Use the latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    # kernelModules = [ "kvm-intel" ];

    # Only use S3 suspend mode, but it not work
    # kernelParams = [
    #   "acpi_rev_override=1"
    #   "acpi_osi=Linux"
    #   "mem_sleep_default=deep"
    # ];
  };



  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.intel.updateMicrocode = true;
}
