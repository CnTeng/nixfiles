{
  hardware' = {
    secure-boot.enable = true;
    serial.enable = true;
    stateless.enable = true;
  };

  boot = {
    initrd.kernelModules = [ "thunderbolt" ];
    initrd.availableKernelModules = [ "usb_storage" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "amd_pstate=active" ];
  };

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.amdgpu.initrd.enable = true;

  services.fwupd.enable = true;
}
