{
  config,
  lib,
  inputs,
  user,
  ...
}:
with lib;
let
  cfg = config.core'.home-manager;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.core'.home-manager.enable = mkEnableOption' { default = true; };

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
