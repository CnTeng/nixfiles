{
  config,
  lib,
  inputs,
  user,
  ...
}:
with lib; let
  cfg = config.basics'.home-manager;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.basics'.home-manager.enable = mkEnableOption "home-manager" // {default = true;};

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs user;};

      users.${user}.home.stateVersion = "23.11";
    };
  };
}
