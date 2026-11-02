{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.sing-box.client;

  trojanPort = 443;
  hysteria2Port = 443;

  mkTrojanOutbound = host: {
    type = "trojan";
    tag = "${host}-trojan";
    server = config.core'.serviceInfo.hosts.${host}.ipv4;
    server_port = trojanPort;
    password._secret = config.sops.secrets."proxy/password".path;
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
    };
  };

  mkHysteria2Outbound = host: {
    type = "hysteria2";
    tag = "${host}-hy2";
    server = config.core'.serviceInfo.hosts.${host}.ipv4;
    server_port = hysteria2Port;
    password._secret = config.sops.secrets."proxy/password".path;
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
    };
  };
in
{
  options.services'.sing-box.client.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    networking.firewall.trustedInterfaces = [ "tun0" ];

    services.sing-box.settings = {
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
            "lssg-trojan"
            "hcde-trojan"
            "lssg-hy2"
            "hcde-hy2"
            "direct"
          ];
          tag = "select";
        }
        (mkTrojanOutbound "lssg")
        (mkTrojanOutbound "hcde")
        (mkHysteria2Outbound "lssg")
        (mkHysteria2Outbound "hcde")
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
  };
}
