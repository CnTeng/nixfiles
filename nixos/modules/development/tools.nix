{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.tools;
in
{
  options.development'.tools.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      perf
      gnumake

      scc
      lrzsz

      pciutils
      usbutils
    ];
  };
}
