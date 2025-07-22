{
  config,
  lib,
  ...
}:
let
  cfg = config.cli'.aichat;
  inherit (config.core') user;
in
{
  options.cli'.aichat.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.aichat.enable = true;
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [ ".config/aichat" ];
    };
  };
}
