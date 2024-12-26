{ config, lib, ... }:
let
  cfg = config.services'.gitea;
in
{
  options.services'.gitea.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    users.users.git = {
      useDefaultShell = true;
      home = config.services.gitea.stateDir;
      group = "gitea";
      isSystemUser = true;
    };

    services.gitea = {
      enable = true;
      user = "git";
      database.user = "git";
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = "git.snakepi.xyz";
          ROOT_URL = "https://git.snakepi.xyz/";
        };
        service.DISABLE_REGISTRATION = true;
        session.COOKIE_SECURE = true;
      };
    };

    services.caddy.virtualHosts.gitea =
      let
        port = config.services.gitea.settings.server.HTTP_PORT;
      in
      {
        hostName = "git.snakepi.xyz";
        extraConfig = ''
          import ${config.sops.templates.cf-tls.path}

          reverse_proxy 127.0.0.1:${toString port}
        '';
      };
  };
}
