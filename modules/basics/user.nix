{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.basics.user;
in {
  options.custom.basics.user = {
    enable = mkEnableOption "user config" // { default = true; };
  };

  config = mkIf cfg.enable {
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      password = "passwd";
    };
  };
}
