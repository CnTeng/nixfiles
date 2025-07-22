{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.restic;
  inherit (config.networking) hostName;
in
{
  options.services'.restic.enable = lib.mkEnableOption "";

  config =
    let
      mkNtfyScript = status: priority: tag: ''
        ${lib.getExe pkgs.curl} -u :$(cat $NTFY_TOKEN) \
          -H "Title: Restic Backup" \
          -H "Priority: ${priority}" \
          -H "Tags: floppy_disk,${tag}" \
          -H "Icon: https://avatars.githubusercontent.com/u/10073512?s=200&v=4" \
          -d "Backup ${hostName} ${status}." \
          https://ntfy.snakepi.xyz/dev
      '';
    in
    lib.mkIf cfg.enable {
      sops.secrets = {
        "restic/password".sopsFile = ./secrets.yaml;
        "restic/ntfy".sopsFile = ./secrets.yaml;

        "restic/endpoint".key = "r2/backups/endpoint";
        "restic/access-key".key = "r2/backups/access_key";
        "restic/secret-key".key = "r2/backups/secret_key";
      };

      sops.templates."restic/repository".content = "s3:${
        config.sops.placeholder."restic/endpoint"
      }/persist/${hostName}";

      sops.templates."restic/environment".content = ''
        AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic/access-key"}
        AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic/secret-key"}
      '';

      services.restic.backups.persist = {
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.templates."restic/environment".path;
        repositoryFile = config.sops.templates."restic/repository".path;
        paths = [ "/persist" ];
        exclude = [ "/persist/home/*/.cache" ];
        timerConfig = {
          OnCalendar = "*-*-* 12:00:00";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
        extraBackupArgs = [ "--exclude-caches" ];
        initialize = true;
        pruneOpts = [
          "--keep-last 5"
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 3"
        ];
        backupPrepareCommand = mkNtfyScript "start" "default" "yellow_circle";
      };

      systemd.services = {
        restic-backups-persist = {
          environment.NTFY_TOKEN = config.sops.secrets."restic/ntfy".path;
          onSuccess = [ "restic-ntfy-success.service" ];
          onFailure = [ "restic-ntfy-failure.service" ];
        };

        restic-ntfy-success = {
          environment.NTFY_TOKEN = config.sops.secrets."restic/ntfy".path;
          script = mkNtfyScript "success" "default" "green_circle";
        };

        restic-ntfy-failure = {
          environment.NTFY_TOKEN = config.sops.secrets."restic/ntfy".path;
          script = mkNtfyScript "failure" "high" "red_circle";
        };
      };

      preservation.preserveAt."/persist".directories = [
        "/var/cache/restic-backups-persist"
      ];
    };
}
