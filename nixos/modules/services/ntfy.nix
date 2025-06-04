{ config, lib, ... }:
let
  cfg = config.services'.ntfy;

  hostName = "ntfy.snakepi.xyz";
  socket = "/run/ntfy-sh/ntfy.sock";
in
{
  options.services'.ntfy.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${hostName}";
        listen-http = "";
        listen-unix = socket;
        listen-unix-mode = 511;
        behind-proxy = true;
      };
    };

    systemd.services.ntfy-sh.serviceConfig.RuntimeDirectory = "ntfy-sh";

    services.caddy.virtualHosts.ntfy = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}

        @httpget {
            protocol http
            method GET
            path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
        }
        redir @httpget https://{host}{uri}
      '';
    };
  };
}
