{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.services'.cache;
in {
  options.services'.cache.enable = mkEnableOption "nix-serve";

  config = mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      package = pkgs.nix-serve-ng;
      port = 5222;
      openFirewall = true;
      secretKeyFile = config.age.secrets.cache.path;
    };

    services.caddy.virtualHosts."cache.snakepi.xyz" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/cache.log
      '';
      extraConfig = ''
        import ${config.age.secrets.caddy.path}

        bind

        encode gzip

        reverse_proxy 127.0.0.1:5222
      '';
    };

    age.secrets.cache = {
      file = ../../secrets/services/cache.age;
      path = "/etc/atticd.env";
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
