{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services'.restic;
  inherit (config.networking) hostName;
in {
  options.services'.restic.enable = mkEnableOption' { };

  config = let
    mkNtfyScript = status: priority: tag: ''
      ${getExe pkgs.curl} -u :$(cat $NTFY_TOKEN) \
        -H "Title: Restic Backup" \
        -H "Priority: ${priority}" \
        -H "Tags: floppy_disk,${tag}" \
        -H "Icon: https://avatars.githubusercontent.com/u/10073512?s=200&v=4" \
        -d "Backup ${hostName} ${status}." \
        https://ntfy.snakepi.xyz/dev
    '';
  in mkIf cfg.enable {
    sops.secrets = {
      "restic/rclone".sopsFile = ./secrets.yaml;
      "restic/password".sopsFile = ./secrets.yaml;
      "restic/ntfy".sopsFile = ./secrets.yaml;
    };

    services.restic.backups.persist = {
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigFile = config.sops.secrets."restic/rclone".path;
      repository = "rclone:onedrive:Backups/persist/${hostName}";
      paths = [ "/persist" ];
      exclude = [ "/persist/home/*/OneDrive" "/persist/home/*/.cache" ];
      timerConfig = {
        OnCalendar = "daily";
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
  };
}
