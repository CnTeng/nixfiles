{ config, lib, user, ... }:
with lib;
let cfg = config.basics'.user;
in {
  options.basics'.user = {
    enable = mkEnableOption "user config" // { default = true; };
  };

  config = mkIf cfg.enable {
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "passwd";
    };
  };
}
