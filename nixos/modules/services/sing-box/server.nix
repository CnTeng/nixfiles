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
  users = [
    {
      name._secret = config.sops.secrets."proxy/username".path;
      password._secret = config.sops.secrets."proxy/password".path;
    }
  ];
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
      globalConfig = /* caddy */ ''
        default_bind 127.0.0.1

        # L4 owns all public HTTP/HTTPS listeners
        layer4 {
          tcp/:80 {
            route {
              proxy tcp/127.0.0.1:80
            }
          }
          tcp/:443 {
            # Trojan clients leave ALPN unset
            @trojan {
              tls sni ${hostName}
              not {
                tls alpn h2 http/1.1
              }
            }
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

    services.caddy.virtualHosts.default = {
      inherit hostName;
      useACMEHost = hostName;
      extraConfig = "respond 404";
    };

    users.users.sing-box.extraGroups = [ certificate.group ];
    systemd.services.sing-box = {
      wants = [ "acme-${hostName}.service" ];
      after = [ "acme-${hostName}.service" ];
    };

    services.sing-box.settings.inbounds = [
      {
        type = "trojan";
        listen = "127.0.0.1";
        listen_port = trojanPort;
        inherit users tls;
        multiplex.enabled = true;
      }
      {
        type = "hysteria2";
        listen = "127.0.0.1";
        listen_port = hysteria2Port;
        inherit users tls;
        ignore_client_bandwidth = true;
      }
    ];

    sops.secrets."proxy/username" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ config.systemd.services.sing-box.name ];
    };
  };
}
