{ config, lib, inputs, ... }:
with lib;
let cfg = config.services'.attic;
in {
  imports = [ inputs.attic.nixosModules.atticd ];
  options.services'.attic.enable = mkEnableOption "Attic";

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 5222 ];

    services.atticd = {
      enable = true;
      credentialsFile = "/etc/atticd.env";

      settings = {
        listen = "[::]:5222";

        chunking = {
          nar-size-threshold = 128 * 1024; # 128 KiB

          min-size = 64 * 1024; # 64 KiB

          avg-size = 128 * 1024; # 128 KiB

          max-size = 256 * 1024; # 256 KiB
        };

      };
    };
    services.caddy.virtualHosts."attic.snakepi.xyz" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/attic.log
      '';
      extraConfig = ''
        import ${config.age.secrets.caddy.path}

        bind

        encode gzip

        reverse_proxy 127.0.0.1:5222
      '';
    };

    age.secrets.attic = {
      file = ../../secrets/services/attic.age;
      path = "/etc/atticd.env";
      owner = "root";
      group = "root";
      mode = "644";
    };
  };
}
