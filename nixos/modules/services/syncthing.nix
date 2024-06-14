{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.services'.syncthing;
  port = 8384;

  inherit (config.networking) hostName;

  hcax-id = "FZI53MV-7BDLDBF-G7ELO44-JEBK3L2-VJIOYT6-KBTSIHT-BTHULAZ-IEVA5AK";
  rxtp-id = "MP7DEJV-GA6NS5O-PA7GKB4-LFXEVPW-EUHFF3D-EVZPS2F-JNDG2L6-CB7T4QA";

  mkFolder = name: {
    ${name} = {
      path = "~/${name}";
      devices = [
        "hcax"
        "rxtp"
      ];
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
in
{
  options.services'.syncthing.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.syncthing = {
      enable = true;
      cert = config.sops.secrets."syncthing/${hostName}-cert".path;
      key = config.sops.secrets."syncthing/${hostName}-key".path;

      settings = {
        options = {
          localAnnounceEnabled = false;
          urAccepted = -1;
        };

        gui = {
          inherit user;
          password = "$2a$10$Bdt741gaItR89NwvIzxhz.liuqP9GheCPIMAICBUtOU7m5aaMIB5u";
        };

        devices = mkDevice "hcax" hcax-id // mkDevice "rxtp" rxtp-id;
        folders = mkFolder "Archives" // mkFolder "Documents" // mkFolder "Pictures";
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
      "syncthing/${hostName}-cert" = {
        owner = user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ "syncthing.service" ];
      };

      "syncthing/${hostName}-key" = {
        owner = user;
        sopsFile = ./secrets.yaml;
        restartUnits = [ "syncthing.service" ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/syncthing" ];
    };
  };
}
