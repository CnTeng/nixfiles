{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.restic;
in {
  options.services'.restic.enable = mkEnableOption "restic";

  config = mkIf cfg.enable {
    sops.secrets = {
      "restic/rclone" = {
        sopsFile = ./secrets.yaml;
        key = "rclone";
      };
      "restic/password".sopsFile = ./secrets.yaml;
    };

    services.restic.backups.persist = {
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigFile = config.sops.secrets."restic/rclone".path;
      repository = "rclone:onedrive:Backups/persist/${config.networking.hostName}";
      paths = ["/persist"];
      exclude = [
        "/persist/home/*/OneDrive"
        "/persist/home/*/.cache"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      extraBackupArgs = ["--exclude-caches"];
      initialize = true;
      pruneOpts = [
        "--keep-last 5"
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
    };
  };
}
