{ inputs, config, lib, pkgs, ... }:
let inherit (config.hardware') persist;
in {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  hardware' = {
    optimise.enable = true;
    nvidia.enable = true;
    persist.enable = true;
    yubikey.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "usb_storage" "i915" ];
  };

  boot.initrd.systemd.enable = true; # Support for luks tpm2

  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  environment.persistence."/persist".directories =
    lib.mkIf persist.enable [ "/etc/secureboot" ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;
}
