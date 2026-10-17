{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services'.restic;

  inherit (config.core') hostName serviceInfo;
in
{
  options.services'.restic.enable = lib.mkEnableOption "";

  config =
    let
      mkTelegramScript = status: emoji: /* bash */ ''
        ${lib.getExe pkgs.curl} --fail --silent --show-error \
          --connect-timeout 10 --max-time 30 --output /dev/null \
          --data-urlencode "chat_id=$TG_CHAT_ID" \
          --data-urlencode ${lib.escapeShellArg "text=${emoji} Restic Backup: ${hostName} ${status}."} \
          "https://api.telegram.org/bot$TG_TOKEN/sendMessage" || true
      '';
    in
    lib.mkIf cfg.enable {
      sops.secrets = {
        "restic/password".sopsFile = ./secrets.yaml;
        "restic/r2_access_key".key = "r2/backups/access_key";
        "restic/r2_secret_key".key = "r2/backups/secret_key";

        "tg-bot/token".sopsFile = ./secrets.yaml;
        "tg-bot/chat_id".sopsFile = ./secrets.yaml;
      };

      sops.templates = {
        "restic/env".content = ''
          AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic/r2_access_key"}
          AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic/r2_secret_key"}
        '';

        "tg-bot/env".content = ''
          TG_TOKEN=${config.sops.placeholder."tg-bot/token"}
          TG_CHAT_ID=${config.sops.placeholder."tg-bot/chat_id"}
        '';
      };

      services.restic.backups.persist = {
        passwordFile = config.sops.secrets."restic/password".path;
        environmentFile = config.sops.templates."restic/env".path;
        repository = "s3:https://${serviceInfo.r2.endpoint}/backups/persist/${hostName}";
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
        backupPrepareCommand = mkTelegramScript "start" "🟡";
      };

      systemd.services.restic-backups-persist = {
        serviceConfig.EnvironmentFile = [ config.sops.templates."tg-bot/env".path ];
        postStop = lib.mkAfter /* bash */ ''
          if [ "$SERVICE_RESULT" = success ]; then
            ${mkTelegramScript "success" "🟢"}
          else
            ${mkTelegramScript "failure" "🔴"}
          fi
        '';
      };

      preservation'.os.directories = [
        "/var/cache/restic-backups-persist"
      ];
    };
}
