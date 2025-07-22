{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware'.secure-boot;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.hardware'.secure-boot.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/sbctl" ];
    };
  };
}
