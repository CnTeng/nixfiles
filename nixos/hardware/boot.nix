{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware'.boot;
in {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.hardware'.boot = {
    enable = mkEnableOption "systemd-boot";
    secureboot = mkEnableOption "secure boot";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      boot.loader = {
        systemd-boot.enable = mkIf (!cfg.secureboot) true;
        efi.canTouchEfiVariables = true;
      };
    })

    (mkIf cfg.secureboot {
      environment.systemPackages = [pkgs.sbctl];

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    })
  ];
}
