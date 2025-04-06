{
  hardware' = {
    secure-boot.enable = true;
    serial.enable = true;
    stateless.enable = true;
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amdgpu.dcdebugmask=0x10"
    ];
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "usb_storage" ];
    initrd.kernelModules = [ "thunderbolt" ];
  };

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.amdgpu.initrd.enable = true;

  services.fwupd.enable = true;
  services.tlp.enable = true;
}
