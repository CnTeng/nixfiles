{ config, lib, ... }:
let
  cfg = config.services'.miniflux;

  hostName = "rss.snakepi.xyz";
  socket = "/run/miniflux.sock";
  user = "miniflux";
in
{
  options.services'.miniflux.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        BASE_URL = "https://${hostName}";
        CREATE_ADMIN = 0;
        DISABLE_LOCAL_AUTH = 1;
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_OIDC_PROVIDER_NAME = "PocketID";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.snakepi.xyz";
        OAUTH2_REDIRECT_URL = "https://${hostName}/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = 1;
      };
      adminCredentialsFile = config.sops.secrets.miniflux.path;
    };

    systemd.sockets.miniflux = {
      description = "Miniflux socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ socket ];
      socketConfig = {
        SocketUser = user;
        SocketGroup = config.users.users.${user}.group;
      };
    };

    services.caddy.virtualHosts.rss = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    users.users.miniflux = {
      group = "miniflux";
      isSystemUser = true;
    };
    users.groups.miniflux = { };

    sops.secrets.miniflux = {
      owner = user;
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.miniflux.name ];
    };
  };
}
