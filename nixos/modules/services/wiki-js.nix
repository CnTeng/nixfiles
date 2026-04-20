{ config, lib, ... }:
let
  cfg = config.services'.wiki-js;

  hostName = "wiki.snakepi.xyz";
in
{
  options.services'.wiki-js.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.wiki-js = {
      enable = true;
      settings.db = {
        host = "/run/postgresql";
        user = "wiki-js";
        db = "wiki-js";
      };
    };

    services.caddy.virtualHosts.wiki-js = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString config.services.wiki-js.settings.port}
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "wiki-js";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "wiki-js" ];
    };
  };
}
