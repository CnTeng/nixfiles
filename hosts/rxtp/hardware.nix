{
  hardware' = {
    secure-boot.enable = true;
    stateless.enable = true;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.zswap.enable = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.amdgpu.initrd.enable = true;
}
