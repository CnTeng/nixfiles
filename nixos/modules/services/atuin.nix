{ config, lib, ... }:
let
  cfg = config.services'.atuin;
in
{
  options.services'.atuin.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.atuin = {
      enable = true;
      openRegistration = true;
    };

    services.caddy.virtualHosts.atuin =
      let
        inherit (config.services.atuin) port;
      in
      {
        hostName = "atuin.snakepi.xyz";
        extraConfig = ''
          import ${config.sops.templates.cf-tls.path}

          reverse_proxy 127.0.0.1:${toString port}
        '';
      };
  };
}
