{ config, lib, ... }:
let
  cfg = config.services'.atuin;

  hostName = "atuin.snakepi.xyz";
in
{
  options.services'.atuin.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.atuin = {
      enable = true;
      openRegistration = true;
    };

    services.caddy.virtualHosts.atuin = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.atuin.port}
      '';
    };
  };
}
