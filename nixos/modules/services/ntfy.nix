{ config, lib, ... }:
let
  cfg = config.services'.ntfy;
in
{
  options.services'.ntfy.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.snakepi.xyz";
        listen-http = "";
        listen-unix = "/run/ntfy-sh/ntfy.sock";
        listen-unix-mode = 511;
        behind-proxy = true;
      };
    };

    systemd.services.ntfy-sh.serviceConfig.RuntimeDirectory = "ntfy-sh";

    services.caddy.virtualHosts.ntfy = {
      hostName = "ntfy.snakepi.xyz";
      extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }

        reverse_proxy "unix/${config.services.ntfy-sh.settings.listen-unix}"

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
