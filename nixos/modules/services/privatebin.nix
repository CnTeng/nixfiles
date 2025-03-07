{ config, lib, ... }:
let
  cfg = config.services'.privatebin;
in
{
  options.services'.privatebin.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.privatebin = {
      enable = true;
      group = "caddy";
      settings = {
        main = {
          basepath = "https://pb.snakepi.xyz/";
          fileupload = true;
          template = "bootstrap5";
          defaultformatter = "syntaxhighlighting";
        };
      };
    };

    services.caddy.virtualHosts.privatebin = {
      hostName = "pb.snakepi.xyz";
      extraConfig = ''
        tls {
          dns cloudflare {$CF_API_TOKEN}
        }

        root * ${config.services.privatebin.package}
        encode gzip

        @php path *.php
        php_fastcgi unix/${config.services.phpfpm.pools.privatebin.socket}

        file_server
        try_files {path} {path}/ /index.php?{query}
      '';
    };
  };
}
