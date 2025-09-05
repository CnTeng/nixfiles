{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.qemu;
in
{
  options.development'.qemu.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qemu ];
  };
}
