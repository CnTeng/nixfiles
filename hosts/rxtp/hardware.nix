{
  inputs,
  config,
  pkgs,
  ...
}:
{

  hardware' = {
    disko = {
      enable = true;
      device = "nvme0n1";
      bootSize = "2G";
      swapSize = "32G";
    };
    secure-boot.enable = true;
    stateless.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [
      "amdgpu"
      "thunderbolt"
    ];
    initrd.availableKernelModules = [ "usb_storage" ];
    kernelModules = [
      "kvm-amd"
      "acpi_call"
    ];
    kernelParams = [ "amd_pstate=active" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
}
