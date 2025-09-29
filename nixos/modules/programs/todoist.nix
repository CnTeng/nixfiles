{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.todoist;
  format = pkgs.formats.toml { };
in
{
  options.programs'.todoist.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      home.packages = [ pkgs.todoist-cli ];

      xdg.configFile = {
        "todoist/config.toml".source = format.generate "config.toml" {
          daemon.api_token_file = config.sops.secrets."todoist/token".path;
        };
      };

      systemd.user.services.todoist-cli = {
        Unit.Description = "Todoist CLI Daemon";

        Install.WantedBy = [ "default.target" ];

        Service = {
          ExecStart = "${lib.getExe pkgs.todoist-cli} daemon";
          Restart = "on-failure";
        };
      };
    };

    sops.secrets."todoist/token" = {
      owner = config.core'.userName;
      sopsFile = ./secrets.yaml;
    };

    preservation'.user.directories = [
      ".config/todoist"
      ".local/share/todoist"
    ];
  };
}
