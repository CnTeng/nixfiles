{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.yubikey;
  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];
in
{
  options.programs'.yubikey.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.udev.packages = yubikeyPkgs;

    environment.systemPackages = yubikeyPkgs;

    programs.yubikey-touch-detector.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/Yubico"
        ".local/share/com.yubico.authenticator"
      ];
    };
  };
}