{
  inputs,
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cli'.todoist;
in
{
  options.cli'.todoist.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      inputs.todoist-cli.homeModules.default
    ];

    home-manager.users.${user} = {
      programs.todoist-cli = {
        enable = true;
        settings = {
          daemon.api_token_file = config.sops.secrets."todoist/token".path;
        };
      };
    };

    sops.secrets."todoist/token" = {
      owner = user;
      sopsFile = ./secrets.yaml;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/todoist"
        ".local/share/todoist"
      ];
    };
  };
}
