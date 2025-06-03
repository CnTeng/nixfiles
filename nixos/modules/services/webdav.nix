{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.services'.webdav;
  socket = "/run/webdav.sock";
in
{
  options.services'.webdav.enable = lib.mkEnableOption' { };

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
            username = user;
            password = "{env}WEBDAV_PASSWORD";
          }
        ];
      };
      environmentFile = config.sops.secrets.webdav-env.path;
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
      hostName = "webdav.snakepi.xyz";
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    sops.secrets.webdav-env = {
      key = "webdav/env";
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.webdav.name ];
    };
  };
}
