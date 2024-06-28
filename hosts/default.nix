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
      data = builtins.fromJSON (builtins.readFile ../infra/outputs/data.json);
      user = "yufei";
    in
    {
      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          nixpkgs = pkgs;
          specialArgs = {
            inherit
              inputs
              lib
              data
              user
              ;
          };
        };

        defaults =
          { name, ... }:
          let
            hostData = data.hosts.${name};
          in
          {
            deployment = {
              allowLocalDeployment = hostData.type == "local";
              tags = [ hostData.type ];
              targetHost = if hostData.type == "local" then null else name;
            };

            nixpkgs.system = hostData.system;

            system.stateVersion = "24.05";

            networking.hostName = name;

            imports = [
              self.nixosModules.default
              ./${name}
            ];
          };

        rxtp = { };

        lssg = { };

        hcax.deployment.buildOnTarget = true;
      };

      nixosConfigurations = self.colmenaHive.nodes;
    }
  );
}
