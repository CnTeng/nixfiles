{ config, lib, ... }:
let
  cfg = config.gui'.kdeconnect;
in
{
  options.gui'.kdeconnect.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };

    hm'.services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    preservation'.user.directories = [ ".config/kdeconnect" ];
  };
}
