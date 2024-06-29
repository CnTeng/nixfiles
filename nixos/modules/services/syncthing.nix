{
  config,
  lib,
  data,
  user,
  ...
}:
let
  cfg = config.services'.syncthing;
  port = 8384;

  inherit (config.networking) hostName;

  hosts = lib.filterAttrs (n: v: v.syncthing) data.hosts;

  authMode = if config.services'.ldap.enable then "ldap" else "static";

  mkFolder = name: devices: {
    ${name} = {
      path = "~/${name}";
      inherit devices;
      versioning = {
        type = "staggered";
        params = {
          cleanInterval = "3600";
          maxAge = "2592000";
        };
      };
    };
  };

  mkDevice = name: id: {
    ${name} = {
      inherit id;
      addresses = [ "dynamic" ];
    };
  };

  devices = lib.concatMapAttrs (host: hostData: mkDevice host hostData.syncthing_id) hosts;
  folders = lib.concatMapAttrs (name: devices: mkFolder name devices) {
    "Archives" = lib.attrNames devices;
    "Documents" = lib.attrNames devices;
    "Pictures" = lib.attrNames devices;
  };

in
{
  options.services'.syncthing.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      cert = config.sops.secrets."syncthing/cert".path;
      key = config.sops.secrets."syncthing/key".path;

      settings = {
        options.urAccepted = -1;

        gui = {
          inherit authMode;
        };

        ldap = {
          address = "localhost:3890";
          bindDN = "cn=%s,ou=people,dc=snakepi,dc=xyz";
          transport = "nontls";
          searchBaseDN = "ou=people,dc=snakepi,dc=xyz";
          searchFilter = "(&(uid=%s)(memberof=cn=lldap_syncthing,ou=groups,dc=snakepi,dc=xyz))";
        };

        inherit devices folders;
      };

      guiAddress = "127.0.0.1:${toString port}";
      inherit user;
      group = "users";
      dataDir = config.users.users.${user}.home;
    };

    services.caddy.virtualHosts.syncthing = {
      hostName = "sync.snakepi.xyz";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port} {
          header_up Host {upstream_hostport}
        }
      '';
    };

    sops.secrets = {
      "syncthing/cert" = {
        key = "hosts/${hostName}/syncthing_key_pair/cert";
        owner = user;
        restartUnits = [ "syncthing.service" ];
      };

      "syncthing/key" = {
        key = "hosts/${hostName}/syncthing_key_pair/key";
        owner = user;
        restartUnits = [ "syncthing.service" ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/syncthing" ];
    };
  };
}
