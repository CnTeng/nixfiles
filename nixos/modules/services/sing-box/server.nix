{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.sing-box.server;

  hostName = config.networking.fqdn;

  trojanPort = 1080;
  hysteria2Port = 1081;

  certificate = config.security.acme.certs.${hostName};
  tls = {
    enabled = true;
    certificate_path = "${certificate.directory}/fullchain.pem";
    key_path = "${certificate.directory}/key.pem";
  };
in
{
  options.services'.sing-box.server.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services'.caddy.enable = true;

    services.caddy = {
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/mholt/caddy-l4@v0.1.2" ];
        hash = "sha256-FwGmHobFqBkEI7LN/YaPsL0t+dJn8uZMhCp9asDEsYw=";
      };
      globalConfig = ''
        default_bind 127.0.0.1

        # L4 owns all public HTTP/HTTPS listeners.
        layer4 {
          tcp/:80 {
            route {
              proxy tcp/127.0.0.1:80
            }
          }
          tcp/:443 {
            @trojan tls sni ${hostName}
            route @trojan {
              proxy tcp/127.0.0.1:${toString trojanPort}
            }
            route {
              proxy tcp/127.0.0.1:443
            }
          }
          udp/:443 {
            @hysteria2 quic sni ${hostName}
            route @hysteria2 {
              proxy udp/127.0.0.1:${toString hysteria2Port}
            }
            route {
              proxy udp/127.0.0.1:443
            }
          }
        }
      '';
    };

    security.acme.certs.${hostName} = {
      group = "sing-box";
      reloadServices = [ config.systemd.services.sing-box.name ];
    };
    systemd.services.sing-box = {
      wants = [ "acme-${hostName}.service" ];
      after = [ "acme-${hostName}.service" ];
    };

    services.sing-box.settings = {
      inbounds = [
        {
          type = "trojan";
          listen = "127.0.0.1";
          listen_port = trojanPort;
          users = [
            {
              name._secret = config.sops.secrets."proxy/username".path;
              password._secret = config.sops.secrets."proxy/password".path;
            }
          ];
          inherit tls;
          multiplex.enabled = true;
        }
        {
          type = "hysteria2";
          listen = "127.0.0.1";
          listen_port = hysteria2Port;
          users = [
            {
              name._secret = config.sops.secrets."proxy/username".path;
              password._secret = config.sops.secrets."proxy/password".path;
            }
          ];
          ignore_client_bandwidth = true;
          bbr_profile = "conservative";
          inherit tls;
        }
      ];
    };

    sops.secrets."proxy/username" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ config.systemd.services.sing-box.name ];
    };
  };
}
