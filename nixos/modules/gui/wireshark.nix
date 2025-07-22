{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.wireshark;
in
{
  options.gui'.wireshark.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    user'.extraGroups = [ "wireshark" ];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
