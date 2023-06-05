{pkgs, ...}: {
  hardware' = {
    gpu.nvidia.enable = true;
    boot = {
      enable = true;
      secureboot = true;
    };
    cpu = {
      intel.enable = true;
      freqGovernor = "powersave";
    };
    devices.enable = true;
    stateless.enable = true;
    ssd.enable = true;
    kernel.modules.zswap = true;
    logitech.enable = true;
    monitor.enable = true;
    power.tlp.enable = true;
    wireless.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];

    tmp.useTmpfs = true;
  };

  systemd.watchdog.runtimeTime = "60s";

  # Support for firmware update
  services.fwupd.enable = true;
}
