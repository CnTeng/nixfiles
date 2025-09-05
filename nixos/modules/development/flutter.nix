{ config, lib, ... }:
let
  cfg = config.development'.flutter;
in
{
  options.development'.flutter.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    preservation'.user.directories = [
      ".dart"
      ".dartServer"
      ".dart-tool"
      ".pub-cache"
    ];
  };
}
