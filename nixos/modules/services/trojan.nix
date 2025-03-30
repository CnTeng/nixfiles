{
  config,
  lib,
  pkgs,
  data,
  ...
}:
let
  cfg = config.services'.trojan;
  port = 10808;

  mkInbound = host: {
    type = "trojan";
    listen = "::";
    listen_port = port;
    users = [
      {
        name._secret = config.sops.secrets."trojan/name".path;
        password._secret = config.sops.secrets."trojan/pass".path;
      }
    ];
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
      acme = {
        domain = "${host}.snakepi.xyz";
        email = "rxsnakepi@gmail.com";
        dns01_challenge = {
          provider = "cloudflare";
          api_token._secret = config.sops.secrets.cf-dns01-token.path;
        };
      };
    };
    multiplex.enabled = true;
  };

  mkOutbound = host: {
    type = "trojan";
    server = data.hosts.${host}.ipv4;
    server_port = port;
    password._secret = config.sops.secrets."trojan/pass".path;
    tls = {
      enabled = true;
      server_name = "${host}.snakepi.xyz";
      utls.enabled = true;
    };
    multiplex.enabled = true;
    tag = host;
  };

in
{
  options.services'.trojan = {
    enableServer = lib.mkEnableOption' { };
    enableClient = lib.mkEnableOption' { };
  };

  config = lib.mkIf (cfg.enableServer || cfg.enableClient) {
    networking.firewall.allowedTCPPorts = [ port ];

    sops.secrets = {
      cf-dns01-token = lib.mkIf cfg.enableServer {
        key = "tokens/cf_tls_token";
        restartUnits = [ "sing-box.service" ];
      };

      "trojan/name" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };

      "trojan/pass" = {
        sopsFile = ./secrets.yaml;
        restartUnits = [ "sing-box.service" ];
      };
    };

    services.sing-box = {
      enable = true;
      settings =
        let
          serverConfig = {
            inbounds = [
              (mkInbound config.networking.hostName)
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
              independent_cache = true;
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
              }
            ];
            outbounds = [
              {
                type = "selector";
                outbounds = [
                  "lssg"
                  "hcde"
                  "auto"
                  "direct"
                ];
                default = "lssg";
                interrupt_exist_connections = false;
                tag = "select";
              }
              {
                type = "urltest";
                outbounds = [
                  "lssg"
                  "hcde"
                ];
                interrupt_exist_connections = false;
                tag = "auto";
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
                  port = 22;
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
              cache_file = {
                enabled = true;
                store_fakeip = true;
              };
              clash_api = {
                external_controller = "127.0.0.1:9090";
                external_ui = pkgs.metacubexd;
              };
            };
          };
        in
        {
          log.level = "info";
        }
        // lib.optionalAttrs cfg.enableServer serverConfig
        // lib.optionalAttrs cfg.enableClient clientConfig;
    };

    networking.firewall.trustedInterfaces = [ "tun0" ];
  };
}
