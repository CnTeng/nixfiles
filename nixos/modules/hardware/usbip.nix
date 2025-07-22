{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware'.usbip;
in
{
  options.hardware'.usbip.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [
      "vhci_hcd"
      "usbip-host"
    ];

    environment.systemPackages = [ pkgs.linuxPackages.usbip ];
  };
}
