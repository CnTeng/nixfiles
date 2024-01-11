{ config, lib, ... }:
with lib;
let cfg = config.services'.caddy;
in {
  options.services'.caddy.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy.enable = true;

    sops.secrets.cf-cdntls-token = {
      key = "outputs/cf_api_token/value";
      owner = config.services.caddy.user;
      sopsFile = config.sops-file.infra;
      restartUnits = [ "caddy.service" ];
    };

    sops.templates.cf-tls = {
      content = ''
        tls {
          dns cloudflare ${config.sops.placeholder.cf-cdntls-token}
        }
      '';
      owner = config.services.caddy.user;
    };
  };
}
