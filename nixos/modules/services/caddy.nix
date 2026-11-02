{
  config,
  lib,
  ...
}:
let
  cfg = config.services'.caddy;
in
{
  options.services'.caddy.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      globalConfig = ''
        admin off
      '';
      enableReload = false;
      openFirewall = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "rxsnakepi@gmail.com";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.sops.secrets.cf_api_token.path;
      };
    };

    sops.secrets.cf_api_token.key = "tokens/cf_tls_token";

    preservation'.os.directories = [
      {
        directory = config.services.caddy.dataDir;
        inherit (config.services.caddy) user group;
      }
      {
        directory = "/var/lib/acme";
        user = "acme";
        group = "acme";
        mode = "0755";
      }
    ];
  };
}
