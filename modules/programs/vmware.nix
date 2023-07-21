{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.vmware;
in {
  options.programs'.vmware.enable = mkEnableOption "VMware";

  config = mkIf cfg.enable {
    virtualisation.vmware.host.enable = true;

    boot.kernelParams = ["transparent_hugepage=never"];

    environment.persistence."/persist" = mkIf config.hardware'.stateless.enable {
      users.${user}.directories = ["OneDrive"];
    };
  };
}
