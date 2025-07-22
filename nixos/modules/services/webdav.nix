{ config, lib, ... }:
let
  cfg = config.services'.webdav;

  hostName = "webdav.snakepi.xyz";
  socket = "/run/webdav.sock";
in
{
  options.services'.webdav.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.webdav = {
      enable = true;
      settings = {
        address = "sd-listen-fd:webdav";
        behindProxy = true;
        directory = "/var/lib/webdav";
        permissions = "CRUD";
        users = [
          {
            username = "{env}WEBDAV_USERNAME";
            password = "{env}WEBDAV_PASSWORD";
          }
        ];
      };
      environmentFile = config.sops.secrets.webdav.path;
    };

    systemd.sockets.webdav = {
      description = "WebDAV socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        FileDescriptorName = "webdav";
        ListenStream = socket;
        SocketUser = config.services.webdav.user;
        SocketGroup = config.services.webdav.group;
      };
    };

    systemd.services.webdav.serviceConfig = {
      StateDirectory = "webdav";
      StateDirectoryMode = "0700";
    };

    services.caddy.virtualHosts.webdav = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    sops.secrets.webdav = {
      owner = config.services.webdav.user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.webdav.name ];
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/webdav" ];
    };
  };
}
