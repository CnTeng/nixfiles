{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    { pkgs, lib, ... }:
    let
      user = "yufei";
    in
    {
      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          nixpkgs = pkgs;
          specialArgs = {
            inherit inputs lib user;
          };
        };

        defaults =
          { lib, name, ... }:
          {
            deployment = {
              targetHost = lib.mkDefault name;
              tags = [ name ];
            };
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
