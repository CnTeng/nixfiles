{ config, lib, ... }:
let
  cfg = config.services'.silverbullet;

  hostName = "note.snakepi.xyz";
  user = "silverbullet";
in
{
  options.services'.silverbullet.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.silverbullet = {
      enable = true;
      envFile = config.sops.secrets.silverbullet.path;
    };

    services.caddy.virtualHosts.note = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString config.services.silverbullet.listenPort}
      '';
    };

    sops.secrets.silverbullet = {
      owner = user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.vaultwarden.name ];
    };

    preservation'.os.directories = [
      {
        directory = config.services.silverbullet.spaceDir;
        inherit (config.services.silverbullet) user group;
      }
    ];
  };
}
