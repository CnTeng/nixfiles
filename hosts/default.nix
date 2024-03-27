{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = withSystem "x86_64-linux" (
    { pkgs, ... }:
    let
      lib = pkgs.lib.extend (self.overlays.lib);
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

        rxdell.deployment = {
          allowLocalDeployment = true;
          targetHost = null;
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
