{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs'.yubikey;
in {
  options.programs'.yubikey.enable = mkEnableOption "YubiKey";

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
      # yubikey-manager
      # yubioath-flutter
    ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      # yubikey-manager
      # yubioath-flutter
    ];

    services.pcscd.enable = true;
  };
}
