{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.services'.anki-sync;
in
{
  options.services'.anki-sync.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
      users = [
        {
          username = user;
          passwordFile = config.sops.secrets.anki-pwd.path;
        }
      ];
    };

    services.caddy.virtualHosts.anki-sync = {
      hostName = "anki.snakepi.xyz";
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.anki-sync-server.port}
      '';
    };

    sops.secrets.anki-pwd = {
      key = "anki/password";
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.anki-sync-server.name ];
    };
  };
}
