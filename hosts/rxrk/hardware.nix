{
  pkgs,
  ...
}:
{
  hardware' = {
    stateless.enable = true;
    usbip.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "rootwait"
      "earlycon"
      "consoleblank=0"
    ];
    initrd.availableKernelModules = [
      "sdhci_acpi"
      "usb_storage"
    ];
  };

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot = {
    enable = true;
    installDeviceTree = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3588-rock-5b.dtb";
  };

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;

  preservation.preserveAt."/persist".directories = [
    "/var/lib/NetworkManager"
    "/etc/NetworkManager/system-connections"
  ];
}
