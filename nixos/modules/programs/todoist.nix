{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs'.todoist;
in
{
  options.programs'.todoist.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [ inputs.todoist-cli.homeModules.default ];

    hm'.programs.todoist-cli = {
      enable = true;
      settings = {
        daemon.api_token_file = config.sops.secrets."todoist/token".path;
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
