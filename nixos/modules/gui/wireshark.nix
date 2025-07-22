{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.wireshark;
  inherit (config.core') user;
in
{
  options.gui'.wireshark.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "wireshark" ];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
