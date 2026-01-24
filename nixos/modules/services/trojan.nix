{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.trojan;

  port = 10808;

  mkOutbound = host: {
    type = "trojan";
    server = "${host}.snakepi.xyz";
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
          server_name = config.networking.fqdn;
          acme = {
            domain = config.networking.fqdn;
            data_directory = "/var/lib/sing-box/certmagic";
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
          tag = "local";
          type = "udp";
          server = "223.5.5.5";
        }
        {
          tag = "remote";
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
          server = "remote";
        }
      ];
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
          format = "binary";
          path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-geolocation-cn.srs";
        }
        {
          type = "local";
          tag = "geoip-cn";
          format = "binary";
          path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
        }
      ];
      default_domain_resolver = "local";
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
    networking.firewall = {
      allowedTCPPorts = lib.mkIf cfg.enableServer [ port ];
      trustedInterfaces = lib.mkIf cfg.enableClient [ "tun0" ];
    };

    services.sing-box = {
      enable = true;
      settings = {
        log.level = "info";
      }
      // lib.optionalAttrs cfg.enableServer serverConfig
      // lib.optionalAttrs cfg.enableClient clientConfig;
    };

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
