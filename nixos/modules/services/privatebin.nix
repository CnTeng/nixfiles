{ config, lib, ... }:
let
  cfg = config.services'.privatebin;

  hostName = "pb.snakepi.xyz";
in
{
  options.services'.privatebin.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.privatebin = {
      enable = true;
      settings.main = {
        basepath = "https://${hostName}/";
        fileupload = true;
        template = "bootstrap5";
        defaultformatter = "syntaxhighlighting";
      };
    };

    services.phpfpm.pools.privatebin = {
      settings."listen.mode" = "0666";
    };

    services.caddy.virtualHosts.privatebin = {
      inherit hostName;
      extraConfig = ''
        root * ${config.services.privatebin.package}
        encode gzip

        @php path *.php
        php_fastcgi unix/${config.services.phpfpm.pools.privatebin.socket}

        file_server
        try_files {path} {path}/ /index.php?{query}
      '';
    };

    preservation'.os.directories = [
      {
        directory = config.services.privatebin.dataDir;
        inherit (config.services.privatebin) user group;
      }
    ];
  };
}
