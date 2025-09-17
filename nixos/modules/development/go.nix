{ config, lib, ... }:
let
  cfg = config.development'.go;
in
{
  options.development'.go.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' =
      { config, ... }:
      {
        programs.go = {
          enable = true;
          env.GOPATH = "${config.xdg.dataHome}/go";
        };
      };

    preservation'.user.directories = [ ".local/share/go" ];
  };
}
