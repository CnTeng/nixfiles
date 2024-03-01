{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.hardware'.yubikey;
  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];
in
{
  options.hardware'.yubikey.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    sops.secrets.yubikey = {
      sopsFile = ./secrets.yaml;
      mode = "0444";
    };

    services.udev.packages = yubikeyPkgs;

    environment.systemPackages = yubikeyPkgs;

    programs.yubikey-touch-detector.enable = true;

    services.pcscd.enable = true;

    security.pam.u2f = {
      enable = true;
      cue = true;
      authFile = config.sops.secrets.yubikey.path;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/Yubico"
        ".local/share/com.yubico.authenticator"
      ];
    };
  };
}
