{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.services'.niks3;

  hostName = "niks3.snakepi.xyz";
  port = 5751;
in
{
  imports = [ inputs.niks3.nixosModules.default ];

  options.services'.niks3.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.niks3 = {
      enable = true;
      httpAddr = "127.0.0.1:${toString port}";

      s3 = {
        inherit (config.core'.serviceInfo.r2) endpoint;
        bucket = "nix-cache";
        region = "auto";
        useSSL = true;
        accessKeyFile = config.sops.secrets."niks3/r2_access_key".path;
        secretKeyFile = config.sops.secrets."niks3/r2_secret_key".path;
      };

      apiTokenFile = config.sops.secrets."niks3/api_token".path;
      signKeyFiles = [ config.sops.secrets."niks3/sign_key".path ];

      oidc.providers.github = {
        issuer = "https://token.actions.githubusercontent.com";
        audience = "https://${hostName}";
        boundClaims.repository_owner = [ "CnTeng" ];
        boundSubject = [ "repo:CnTeng/*:*" ];
      };

      cacheUrl = "https://cache.snakepi.xyz";
      serverUrl = "https://${hostName}";
    };

    systemd.services.niks3.environment.NIX_CACHE_PRIORITY = "50";

    services.caddy.virtualHosts.niks3 = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString port}
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

      "niks3/r2_access_key" = {
        key = "r2/nix_cache/access_key";
        owner = config.services.niks3.user;
      };

      "niks3/r2_secret_key" = {
        key = "r2/nix_cache/secret_key";
        owner = config.services.niks3.user;
      };
    };

    preservation'.os.directories = [
      {
        directory = "/var/lib/niks3";
        inherit (config.services.niks3) user group;
        mode = "0700";
      }
    ];
  };
}
