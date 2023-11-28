{ config, lib, inputs, user, ... }:
with lib;
let cfg = config.basics'.home-manager;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.basics'.home-manager.enable = mkEnableOption "home-manager" // {
    default = true;
  };

  config = mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    home-manager.users.${user} = {
      home.stateVersion = config.system.stateVersion;
    };
  };
}
