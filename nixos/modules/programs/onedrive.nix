{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.onedrive;
in
{
  options.programs'.onedrive.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      programs.onedrive = {
        enable = true;
        settings = {
          sync_dir = "~";
          sync_dir_permissions = "0755";
          sync_file_permissions = "0644";
        };
      };

      xdg.configFile."onedrive/sync_list".text = ''
        /Documents/
        /Pictures/
      '';

      systemd.user.services.onedrive = {
        Unit = {
          Description = "OneDrive Client for Linux";
          Documentation = "https://github.com/abraunegg/onedrive";
          Wants = [ "network-online.target" ];
          After = [ "network-online.target" ];
        };

        Service = {
          ProtectSystem = "full";
          ProtectHostname = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictRealtime = true;
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 15";
          ExecStart = "${lib.getExe pkgs.onedrive} --monitor";
          Restart = "on-failure";
          RestartSec = 3;
          RestartPreventExitStatus = 126;
          TimeoutStopSec = 90;
        };

        Install.WantedBy = [ "default.target" ];
      };
    };

    preservation'.user.directories = [
      {
        directory = ".config/onedrive";
        mode = "0700";
      }
    ];
  };
}
