{ config, lib, user, ... }:
with lib;
let cfg = config.utils'.yazi;
in {
  options.utils'.yazi.enable = mkEnableOption' { default = true; };

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
