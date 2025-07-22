{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.yubikey;

  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];
in
{
  options.gui'.yubikey.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;

    services.udev.packages = yubikeyPkgs;

    environment.systemPackages = yubikeyPkgs;

    programs.yubikey-touch-detector.enable = true;

    preservation'.user.directories = [
      ".config/Yubico"
      ".local/share/com.yubico.authenticator"
    ];
  };
}
