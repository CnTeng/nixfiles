{ config, lib, ... }:
let
  cfg = config.services'.atuin;
  port = 9222;
in
{
  options.services'.atuin.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.atuin = {
      enable = true;
      inherit port;
      openFirewall = true;
      openRegistration = true;
    };

    services.caddy.virtualHosts.atuin = {
      hostName = "atuin.snakepi.xyz";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
