{
  hardware' = {
    secure-boot.enable = true;
    serial.enable = true;
    stateless.enable = true;
    usbip.enable = true;
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amdgpu.dcdebugmask=0x10"
    ];
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [
      "thunderbolt"
      "usb_storage"
    ];
  };

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.amdgpu.initrd.enable = true;

  services.fwupd.enable = true;
  services.tlp.enable = true;

  preservation.preserveAt."/persist".directories = [
    "/var/lib/fwupd"
    "/var/cache/fwupd"

    "/var/lib/tlp"
  ];
}
