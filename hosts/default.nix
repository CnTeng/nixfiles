{
  inputs,
  lib,
  self,
  ...
}:
let
  data = lib.importJSON ../infra/outputs/data.json;

  mkNixosSystem = host: _: {
    ${host} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs data;
      };
      modules = [
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
            hostPlatform = data.hosts.${host}.system;
          };

          core' = {
            userName = "yufei";
            hostName = host;
            stateVersion = "25.05";
          };
        }
        self.nixosModules.default
        ./${host}
      ];
    };
  };
in
{
  flake.nixosConfigurations = lib.pipe (builtins.readDir ./.) [
    (lib.filterAttrs (n: _: n != "default.nix"))
    (lib.concatMapAttrs mkNixosSystem)
  ];
}
