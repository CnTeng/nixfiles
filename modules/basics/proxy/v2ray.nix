{ ... }:

{
  services.v2ray = {
    enable = true;
    config = {
      log = {
        loglevel = "info";
      };
      dns = {
        disableFallbackIfMatch = true;
        servers = [
          {
            address = "tls://dns.google";
            concurrency = true;
          }
          {
            address = "localhost";
            concurrency = true;
            domains = [
              "geosite:cn"
              "full:dns.google"
            ];
            skipFallback = true;
          }
        ];
      };
      inbounds = [
        {
          listen = "127.0.0.1";
          port = 10808;
          protocol = "socks";
          settings = {
            auth = "noauth";
            udp = true;
          };
          sniffing = {
            destOverride = [
              "http"
              "tls"
            ];
            enabled = true;
          };
          tag = "socks";
        }
        {
          listen = "127.0.0.1";
          port = 10809;
          protocol = "http";
          settings = { };
          sniffing = {
            destOverride = [
              "http"
              "tls"
            ];
            enabled = true;
          };
          tag = "http";
        }
      ];
      outbounds = [
        {
          protocol = "http";
          settings = {
            servers = [
              {
                address = "127.0.0.1";
                port = 1080;
              }
            ];
          };
          tag = "proxy";
        }
        {
          protocol = "freedom";
          settings = { };
          tag = "direct";
        }
      ];
      routing = {
        rules = [
          {
            domainMatcher = "mph";
            type = "field";
            domains = [
              "geosite:cn"
              "domain:snakepi.xyz"
              "domain:tuna.tsinghua.edu.cn"
              "domain:novipnoad.com"
            ];
            outboundTag = "direct";
          }
          {
            domainMatcher = "mph";
            type = "field";
            ip = [
              "geoip:cn"
              "geoip:private"
            ];
            outboundTag = "direct";
          }
        ];
      };
    };
  };
}
