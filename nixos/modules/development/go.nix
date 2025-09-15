{ config, lib, ... }:
let
  cfg = config.development'.go;
in
{
  options.development'.go.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.go = {
      enable = true;
      env.GOPATH = ".local/share/go";
    };

    preservation'.user.directories = [ ".local/share/go" ];
  };
}
