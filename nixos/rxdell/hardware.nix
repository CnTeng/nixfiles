{ pkgs, ... }: {
  hardware' = {
    gpu.nvidia.enable = true;
    boot.enable = true;
    cpu = {
      intel.enable = true;
      freqGovernor = "powersave";
    };
    devices.enable = true;
    ssd.enable = true;
    kernel.modules.zswap = true;
    power.tlp.enable = true;
    wireless.enable = true;
  };

  boot = {
    # Use the latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  };

  systemd.watchdog.runtimeTime = "60s";

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
