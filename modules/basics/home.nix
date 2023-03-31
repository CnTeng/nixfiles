{ config, lib, inputs, user, ... }:

with lib;

let cfg = config.custom.basics.home-manager;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.custom.basics.home-manager = {
    enable = mkEnableOption "home-manager" // { default = true; };
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs user; };

      users.${user} = {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "23.05";
        };

        programs = { home-manager.enable = true; };
      };
    };
  };
}