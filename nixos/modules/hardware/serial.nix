{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware'.serial;
in
{
  options.hardware'.serial.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.usbutils ];

    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="067b", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", MODE:="0666"
    '';

    i18n.supportedLocales = [
      (config.i18n.defaultLocale + "/UTF-8")
      "zh_CN.GBK/GBK"
    ];
  };
}
