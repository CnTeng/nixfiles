{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    { pkgs, lib, ... }:
    {
      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          nixpkgs = pkgs;
          specialArgs = {
            inherit inputs lib;
            user = "yufei";
          };
        };

        defaults =
          { lib, name, ... }:
          {
            deployment = {
              targetHost = lib.mkDefault name;
              tags = [ name ];
            };

            system.stateVersion = "24.05";

            networking.hostName = name;

            imports = [
              self.nixosModules.default
              ./${name}
            ];
          };

        rxtp.deployment = {
          allowLocalDeployment = true;
          targetHost = null;
        };

        lssg.deployment = { };

        hcax = {
          deployment.buildOnTarget = true;
          nixpkgs.system = "aarch64-linux";
        };
      };

      nixosConfigurations = self.colmenaHive.nodes;
    }
  );
}
