{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
  ];

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
    yubikey-touch-detector
  ];

  services.pcscd.enable = true;
}
