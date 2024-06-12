{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.serial;
in
{
  options.programs'.serial.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [
      "ftdi_sio"
      "pl2303"
    ];

    environment.systemPackages = with pkgs; [
      picocom
      usbutils
    ];

    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5523", MODE:="0666"
    '';

    i18n.supportedLocales = [
      (config.i18n.defaultLocale + "/UTF-8")
      "zh_CN.GBK/GBK"
    ];
  };
}
