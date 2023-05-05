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
    secureboot = mkEnableOption "Secure Boot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.sbctl];

    boot.lanzaboote = mkIf cfg.secureboot {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = mkIf (!cfg.secureboot) true;
    };

    boot.plymouth = {
      enable = true;
      themePackages = [pkgs.catppuccin-plymouth];
      theme = "catppuccin-macchiato";
    };
  };
}
