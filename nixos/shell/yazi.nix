{ config, lib, user, ... }:
with lib;
let cfg = config.shell'.yazi;
in {
  options.shell'.yazi.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
