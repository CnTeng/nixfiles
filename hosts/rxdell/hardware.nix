{ pkgs, config, ... }: {
  imports = [ ../../modules/hardware ];

  custom.hardware = {
    gpu.nvidia.enable = true;
    boot.enable = true;
    cpu = {
      intel.enable = true;
      cpuFreqGovernor = "ondemand";
    };
    devices.enable = true;
    ssd.enable = true;
    kernel.modules.zswap = true;
    kvm = {
      enable = true;
      passthrough.intel = true;
    };
    power.tlp.enable = true;
    wireless.enable = true;
  };

  boot = {
    # Use the latest kernel
    kernelPackages = pkgs.linuxPackages_6_1;

    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
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

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  # Support for firmware update
  services.fwupd.enable = true;
}
