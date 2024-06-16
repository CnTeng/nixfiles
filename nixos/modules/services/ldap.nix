{ config, lib, ... }:
let
  cfg = config.services'.ldap;
  port = config.services.lldap.settings.http_port;
in
{
  options.services'.ldap.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.lldap = {
      enable = true;
      settings = {
        http_url = "https://ldap.snakepi.xyz";
        ldap_base_dn = "dc=snakepi,dc=xyz";
        ldap_user_email = "rxsnakepi@gmail.com";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt_secret".path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/ldap_user_pass".path;
      };

    };

    services.caddy.virtualHosts.lldap = {
      hostName = "ldap.snakepi.xyz";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

    users.users.lldap = {
      group = "lldap";
      isSystemUser = true;
    };
    users.groups.lldap = { };

    sops.secrets = {
      "lldap/jwt_secret" = {
        owner = "lldap";
        sopsFile = ./secrets.yaml;
      };

      "lldap/ldap_user_pass" = {
        owner = "lldap";
        sopsFile = ./secrets.yaml;
      };
    };
  };
}
