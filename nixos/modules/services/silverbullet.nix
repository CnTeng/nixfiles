{ config, lib, ... }:
let
  cfg = config.services'.silverbullet;

  hostName = "note.snakepi.xyz";
  socket = "@silverbullet.sock";
in
{
  options.services'.silverbullet.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.silverbullet = {
      enable = true;
      envFile = config.sops.secrets.silverbullet.path;
    };

    systemd.services.silverbullet.environment.SB_UNIX_SOCKET = socket;

    services.caddy.virtualHosts.note = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    sops.secrets.silverbullet = {
      owner = config.services.silverbullet.user;
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
