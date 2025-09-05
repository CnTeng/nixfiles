{ config, lib, ... }:
let
  cfg = config.programs'.kdeconnect;
in
{
  options.programs'.kdeconnect.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;

    hm'.services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    preservation'.user.directories = [ ".config/kdeconnect" ];
  };
}
