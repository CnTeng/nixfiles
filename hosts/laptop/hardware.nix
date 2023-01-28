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
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "zstd"
      "z3fold"
    ];

    # Enabled zswap
    kernelModules = [ "zstd" "zsfold" ];
    kernelParams = [
      "zswap.enabled=1"
      "zswap.max_pool_percent=25"
    ];
    postBootCommands = ''
      echo zstd > /sys/module/zswap/parameters/compressor
      echo z3fold > /sys/module/zswap/parameters/zpool
    '';
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

  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = true;

  # Support for firmware update
  services.fwupd.enable = true;
}
