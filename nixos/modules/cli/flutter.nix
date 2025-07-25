{ config, lib, ... }:
let
  cfg = config.cli'.flutter;
in
{
  options.cli'.flutter.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    preservation'.user.directories = [
      ".dart"
      ".dartServer"
      ".dart-tool"
      ".pub-cache"
    ];
  };
}
