{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.kdeconnect;
in
{
  options.gui'.kdeconnect.enable = lib.mkEnableOption' { };

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

    home-manager.users.${user} = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/kdeconnect" ];
    };
  };
}
