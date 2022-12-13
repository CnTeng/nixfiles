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
  ];

  services.pcscd.enable = true;
}
