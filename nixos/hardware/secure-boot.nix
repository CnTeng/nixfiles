{ inputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hardware'.secure-boot;
  inherit (config.hardware') persist;
in {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.hardware'.secure-boot.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    environment.persistence."/persist".directories = mkIf persist.enable [{
      directory = "/etc/secureboot";
      user = "root";
      group = "root";
      mode = "u=rwx,g=rx,o=rx";
    }];
  };
}
