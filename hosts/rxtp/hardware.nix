{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.hardware') persist;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  hardware' = {
    disko = {
      enable = true;
      device = "nvme0n1";
      bootSize = "2G";
      swapSize = "32G";
    };
    persist.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "amdgpu" ];
    initrd.availableKernelModules = [ "usb_storage" ];
  };

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  environment.persistence."/persist".directories = lib.mkIf persist.enable [ "/etc/secureboot" ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
