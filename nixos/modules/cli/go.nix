{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cli'.go;
in
{
  options.cli'.go.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.go = {
        enable = true;
        goPath = ".local/share/go";
      };
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [ ".local/share/go" ];
    };
  };
}
