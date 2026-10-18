{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.trojan;

  hostName = config.networking.fqdn;
  port = 1080;

  mkOutbound = host: {
    type = "trojan";
    tag = host;
    server = config.core'.serviceInfo.hosts.${host}.ipv4;
    server_port = 443;
    password._secret = config.sops.secrets."proxy/password".path;
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
    };
    transport = {
      type = "ws";
      path = "/trojan";
      headers.Host = "${host}.snakepi.xyz";
    };
    multiplex.enabled = true;
  };

  serverConfig = {
    inbounds = [
      {
        type = "trojan";
        listen = "127.0.0.1";
        listen_port = port;
        users = [
          {
            name._secret = config.sops.secrets."proxy/username".path;
            password._secret = config.sops.secrets."proxy/password".path;
          }
        ];
        transport = {
          type = "ws";
          path = "/trojan";
        };
        multiplex.enabled = true;
      }
    ];
  };

  clientConfig = {
    http_clients = [
      {
        tag = "proxy";
        detour = "select";
      }
    ];
    dns = {
      servers = [
        {
          tag = "local";
          type = "udp";
          server = "223.5.5.5";
        }
        {
          tag = "remote";
          type = "https";
          server = "1.1.1.1";
          detour = "select";
        }
        {
          tag = "fakeip";
          type = "fakeip";
          inet4_range = "198.18.0.0/15";
          inet6_range = "fc00::/18";
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
          query_type = [
            "A"
            "AAAA"
          ];
          server = "fakeip";
        }
      ];
      final = "remote";
      reverse_mapping = true;
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
        exclude_interface = [ "tailscale0" ];
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
        { action = "sniff"; }
        {
          protocol = "dns";
          action = "hijack-dns";
        }
        {
          ip_is_private = true;
          outbound = "direct";
        }
        {
          ip_cidr = [ "100.64.0.0/10" ];
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
          path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-geolocation-cn.srs";
        }
        {
          type = "local";
          tag = "geoip-cn";
          path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
        }
      ];
      final = "select";
      default_domain_resolver = "local";
      auto_detect_interface = true;
    };
    services = [
      {
        type = "api";
        listen = "127.0.0.1";
        listen_port = 9090;
        dashboard = "${pkgs.sing-box-dashboard}";
      }
    ];
    experimental.cache_file = {
      enabled = true;
      store_fakeip = true;
    };
  };
in
{
  options.services'.trojan = {
    enableServer = lib.mkEnableOption "";
    enableClient = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enableServer || cfg.enableClient) {
    services'.caddy.enable = lib.mkIf cfg.enableServer true;

    services.caddy.virtualHosts.trojan = lib.mkIf cfg.enableServer {
      inherit hostName;
      extraConfig = ''
        handle /trojan {
          reverse_proxy 127.0.0.1:${toString port}
        }
        handle {
          respond 404
        }
      '';
    };

    networking.firewall.trustedInterfaces = lib.mkIf cfg.enableClient [ "tun0" ];

    services.sing-box = {
      enable = true;
      settings = {
        log.level = "error";
      }
      // lib.optionalAttrs cfg.enableServer serverConfig
      // lib.optionalAttrs cfg.enableClient clientConfig;
    };

    sops.secrets = {
      "proxy/username" = lib.mkIf cfg.enableServer {
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.sing-box.name ];
      };

      "proxy/password" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ config.systemd.services.sing-box.name ];
      };
    };

    preservation'.os.directories = [
      {
        directory = "/var/lib/sing-box";
        user = "sing-box";
        group = "sing-box";
        mode = "0700";
      }
    ];
  };
}
