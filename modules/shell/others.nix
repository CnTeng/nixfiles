{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.shell.module;
in {
  options.shell.module = {
    others = mkEnableOption "others" // { default = cfg.enable; };
  };

  config = mkIf cfg.others {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ unzip gzip unrar wget neofetch ];
    };
  };
}
