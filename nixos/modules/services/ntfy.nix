{ config, lib, ... }:
let
  cfg = config.services'.ntfy;
  port = 7222;
in
{
  options.services'.ntfy.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.snakepi.xyz";
        listen-http = ":${toString port}";
        behind-proxy = true;
      };
    };

    services.caddy.virtualHosts.ntfy = {
      hostName = "ntfy.snakepi.xyz";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
