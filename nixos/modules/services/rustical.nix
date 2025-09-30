{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.rustical;
  format = pkgs.formats.toml { };

  hostName = "cal.snakepi.xyz";
  port = 4000;

  settings = {
    data_store.sqlite.db_url = "/var/lib/rustical/db.sqlite3";

    http = {
      host = "127.0.0.1";
      inherit port;
    };

    frontend = {
      enabled = true;
      allow_password_login = false;
    };

    dav_push.enabled = true;
    nextcloud_login.enabled = true;

    oidc = {
      name = "PocketID";
      issuer = "https://id.snakepi.xyz";
      claim_userid = "preferred_username";
      scopes = [
        "openid"
        "profile"
        "groups"
      ];
      allow_sign_up = true;
    };
  };
in
{
  options.services'.rustical.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    systemd.services.rustical = {
      description = "A CalDAV/CardDAV server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.rustical} --config-file ${format.generate "config.toml" settings}";
        EnvironmentFile = config.sops.secrets.rustical.path;
        StateDirectory = "rustical";
        StateDirectoryMode = "0700";
        User = "rustical";
        Group = "rustical";
        Restart = "on-failure";
      };
    };

    services.caddy.virtualHosts.rustical = {
      inherit hostName;
      extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };

    users.users.rustical = {
      group = "rustical";
      isSystemUser = true;
    };
    users.groups.rustical = { };

    sops.secrets.rustical = {
      owner = "rustical";
      sopsFile = ./secrets.yaml;
      restartUnits = [ config.systemd.services.rustical.name ];
    };

    preservation'.os.directories = [
      {
        directory = "/var/lib/rustical";
        user = "rustical";
        group = "rustical";
        mode = "0700";
      }
    ];
  };
}
