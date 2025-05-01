{
  pkgs,
  ...
}:
{
  hardware'.stateless.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_testing;
    kernelParams = [
      "rootwait"
      "earlycon"
      "consoleblank=0"
      "console=tty1"
    ];
    initrd.availableKernelModules = [
      "sdhci_acpi"
      "usb_storage"
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.installDeviceTree = true;
  hardware.deviceTree = {
    enable = true;
    name = "rockchip/rk3588-rock-5b.dtb";
  };

  hardware.enableRedistributableFirmware = true;
}
