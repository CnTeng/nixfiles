{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.services'.niks3;

  hostName = "niks3.snakepi.xyz";
  socket = "/run/niks3.sock";
in
{
  imports = [ inputs.niks3.nixosModules.default ];

  options.services'.niks3.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.niks3 = {
      enable = true;

      s3 = {
        endpoint = "c351f1c6712517e99c7a22cb196a98a2.r2.cloudflarestorage.com";
        bucket = "nix-cache";
        region = "auto";
        useSSL = true;
        accessKeyFile = config.sops.secrets."niks3/access-key".path;
        secretKeyFile = config.sops.secrets."niks3/secret-key".path;
      };

      apiTokenFile = config.sops.secrets."niks3/api_token".path;
      signKeyFiles = [ config.sops.secrets."niks3/sign_key".path ];

      cacheUrl = "https://cache.snakepi.xyz";
      serverUrl = "https://${hostName}";
    };

    systemd.sockets.niks3 = {
      listenStreams = [ socket ];
      socketConfig = {
        SocketUser = config.services.niks3.user;
        SocketGroup = config.services.niks3.group;
      };
    };

    services.caddy.virtualHosts.niks3 = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy unix/${socket}
      '';
    };

    sops.secrets = {
      "niks3/api_token" = {
        owner = config.services.niks3.user;
        sopsFile = ./secrets.yaml;
      };

      "niks3/sign_key" = {
        owner = config.services.niks3.user;
        sopsFile = ./secrets.yaml;
      };

      "niks3/endpoint" = {
        key = "r2/nix_cache/endpoint";
        owner = config.services.niks3.user;
      };

      "niks3/access-key" = {
        key = "r2/nix_cache/access_key";
        owner = config.services.niks3.user;
      };

      "niks3/secret-key" = {
        key = "r2/nix_cache/secret_key";
        owner = config.services.niks3.user;
      };
    };
  };
}
