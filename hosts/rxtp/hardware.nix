{ inputs, pkgs, ... }:
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
      "amd-pstate"
    ];
    kernelParams = [
      "initcall_blacklist=acpi_cpufreq_init"
      "amd_pstate=active"
    ];
  };

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  environment.systemPackages = [ pkgs.sbctl ];

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
}
