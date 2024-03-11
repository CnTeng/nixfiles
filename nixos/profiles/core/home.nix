{
  config,
  inputs,
  user,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };

  home-manager.users.${user} = {
    home.stateVersion = config.system.stateVersion;
  };
}
