{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.shell.bat;
in {
  options.custom.shell.bat = {
    enable = mkEnableOption "bat" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;

      };
    };
  };
}
