{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.services'.calibre-web;
  inherit (config.users.users.${user}) home;
in {
  options.services'.calibre-web.enable = mkEnableOption "Calibre-Web";

  config = mkIf cfg.enable {
    services = {
      calibre-web = {
        enable = true;
        inherit user;
        group = "users";
        listen = {
          ip = "127.0.0.1";
          port = 7222;
        };
        openFirewall = true;
        options = {
          enableBookUploading = true;
          enableBookConversion = true;
          calibreLibrary = "${home}/OneDrive/Calibre";
        };
      };

      caddy.virtualHosts."book.snakepi.xyz" = {
        logFormat = "output stdout";
        extraConfig = ''
          import ${config.sops.secrets.cloudflare.path}

          bind

          encode gzip

          reverse_proxy 127.0.0.1:7222
        '';
      };
    };
  };
}
