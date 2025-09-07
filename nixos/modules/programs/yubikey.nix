{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.yubikey;
in
{
  options.programs'.yubikey.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.yubikey-manager.enable = true;
    programs.yubikey-touch-detector.enable = true;

    environment.systemPackages = [ pkgs.yubioath-flutter ];

    preservation'.user.directories = [
      ".config/Yubico"
      ".local/share/com.yubico.authenticator"
    ];
  };
}
