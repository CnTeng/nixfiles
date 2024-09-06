{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cli'.flutter;
in
{
  options.cli'.flutter.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      users.${user} = {
        files = [ ".flutter" ];
        directories = [
          ".dart"
          ".dartServer"
          ".dart-tool"
          ".pub-cache"
        ];
      };
    };
  };
}
