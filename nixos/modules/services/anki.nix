{ config, lib, ... }:
let
  cfg = config.services'.anki-sync;

  hostName = "anki.snakepi.xyz";
in
{
  options.services'.anki-sync.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
      users = [
        {
          username = config.core'.userName;
          passwordFile = config.sops.secrets."anki/password".path;
        }
      ];
    };

    services.caddy.virtualHosts.anki-sync = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString config.services.anki-sync-server.port}
      '';
    };

    sops.secrets."anki/password" = {
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.anki-sync-server.name ];
    };
  };
}
