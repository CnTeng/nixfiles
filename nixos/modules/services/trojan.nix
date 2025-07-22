{
  config,
  lib,
  pkgs,
  data,
  ...
}:
let
  cfg = config.services'.trojan;

  hostName = "${config.core'.hostName}.snakepi.xyz";
  port = 10808;

  mkOutbound = host: {
    type = "trojan";
    server = data.hosts.${host}.ipv4;
    server_port = port;
    password._secret = config.sops.secrets."proxy/password".path;
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
      utls.enabled = true;
    };
    multiplex.enabled = true;
    tag = host;
  };

  serverConfig = {
    inbounds = [
      {
        type = "trojan";
        listen = "::";
        listen_port = port;
        users = [
          {
            name._secret = config.sops.secrets."proxy/username".path;
            password._secret = config.sops.secrets."proxy/password".path;
          }
        ];
        tls = {
          enabled = true;
          server_name = hostName;
          acme = {
            domain = hostName;
            email = "rxsnakepi@gmail.com";
            dns01_challenge = {
              provider = "cloudflare";
              api_token._secret = config.sops.secrets.cf-dns01-token.path;
            };
          };
        };
        multiplex.enabled = true;
      }
    ];
  };

  clientConfig = {
    dns = {
      servers = [
        {
          tag = "google";
          address = "tls://8.8.8.8";
        }
        {
          tag = "local";
          address = "223.5.5.5";
          detour = "direct";
        }
        {
          tag = "remote";
          address = "fakeip";
        }
      ];
      rules = [
        {
          domain_keyword = [ "tailscale" ];
          server = "local";
        }
        {
          rule_set = "geosite-cn";
          server = "local";
        }
        {
          outbound = "any";
          server = "local";
        }
        {
          query_type = [
            "A"
            "AAAA"
          ];
          server = "remote";
        }
      ];
      fakeip = {
        enabled = true;
        inet4_range = "198.18.0.0/15";
        inet6_range = "fc00::/18";
      };
      strategy = "ipv4_only";
    };
    inbounds = [
      {
        type = "tun";
        interface_name = "tun0";
        address = [
          "172.19.0.1/30"
          "fdfe:dcba:9876::1/126"
        ];
        auto_route = true;
        strict_route = false;
        exclude_interface = [ "tailscale0" ];
      }
      {
        type = "mixed";
        listen = "0.0.0.0";
        listen_port = port;
        sniff = true;
        users = [
          {
            username._secret = config.sops.secrets."proxy/username".path;
            password._secret = config.sops.secrets."proxy/password".path;
          }
        ];
      }
    ];
    outbounds = [
      {
        type = "selector";
        outbounds = [
          "lssg"
          "hcde"
          "direct"
        ];
        default = "lssg";
        interrupt_exist_connections = false;
        tag = "select";
      }
      (mkOutbound "lssg")
      (mkOutbound "hcde")
      {
        type = "direct";
        tag = "direct";
      }
    ];
    route = {
      rules = [
        {
          action = "sniff";
        }
        {
          protocol = "dns";
          action = "hijack-dns";
        }
        {
          ip_is_private = true;
          outbound = "direct";
        }
        {
          port = [
            22
            2222
          ];
          outbound = "direct";
        }
        {
          rule_set = [
            "geoip-cn"
            "geosite-cn"
          ];
          outbound = "direct";
        }
      ];
      rule_set = [
        {
          type = "local";
          tag = "geosite-cn";
          format = "binary";
          path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
        }
        {
          type = "local";
          tag = "geoip-cn";
          format = "binary";
          path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
        }
      ];
      auto_detect_interface = true;
    };
    experimental = {
      clash_api = {
        external_controller = "127.0.0.1:9090";
        external_ui = pkgs.metacubexd;
      };
    };
  };
in
{
  options.services'.trojan = {
    enableServer = lib.mkEnableOption "";
    enableClient = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enableServer || cfg.enableClient) {
    networking.firewall.allowedTCPPorts = [ port ];

    services.sing-box = {
      enable = true;
      settings =
        {
          log.level = "info";
        }
        // lib.optionalAttrs cfg.enableServer serverConfig
        // lib.optionalAttrs cfg.enableClient clientConfig;
    };

    networking.firewall.trustedInterfaces = [ "tun0" ];

    sops.secrets = {
      cf-dns01-token = lib.mkIf cfg.enableServer {
        key = "tokens/cf_tls_token";
        restartUnits = [ config.systemd.services.sing-box.name ];
      };

      "proxy/username" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.sing-box.name ];
      };

      "proxy/password" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.sing-box.name ];
      };
    };

    preservation.preserveAt."/persist" = {
      directories = [ "/var/lib/sing-box" ];
    };
  };
}
