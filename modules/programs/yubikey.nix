{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.programs.yubikey;
in {
  options.custom.programs.yubikey = { enable = mkEnableOption "yubikey"; };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubioath-flutter
    ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubioath-flutter
    ];

    services.pcscd.enable = true;
  };
}
