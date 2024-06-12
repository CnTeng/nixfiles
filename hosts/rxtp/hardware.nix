{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  hardware' = {
    disko = {
      enable = true;
      device = "nvme0n1";
      bootSize = "2G";
      swapSize = "32G";
    };
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

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.vulkan-tools
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  environment.persistence."/persist".directories = [ "/etc/secureboot" ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };
}
