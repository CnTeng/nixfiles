{ config, lib, user, ... }:
with lib;
let
  cfg = config.services'.miniflux;
  port = 6222;
in {
  options.services'.miniflux.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:${toString port}";
        BASE_URL = "https://rss.snakepi.xyz";
        WEBAUTHN = "1";
      };
      adminCredentialsFile = config.sops.secrets.miniflux.path;
    };

    services.caddy.virtualHosts."rss.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

    sops.secrets.miniflux = {
      owner = user;
      sopsFile = ./secrets.yaml;
    };
  };
}
