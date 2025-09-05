{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development'.wireshark;
in
{
  options.development'.wireshark.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    user'.extraGroups = [ "wireshark" ];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
