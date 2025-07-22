{
  inputs,
  lib,
  self,
  ...
}:
let
  data = lib.importJSON ../infra/outputs/data.json;
  user = "yufei";

  mkNixosSystem = host: _: {
    ${host} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs data user;
      };
      modules = [
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ self.overlays.default ];
            hostPlatform = data.hosts.${host}.system;
          };

          networking.hostName = host;
          system.stateVersion = "25.05";
        }
        self.nixosModules.default
        ./${host}
      ];
    };
  };
in
{
  flake.nixosConfigurations = lib.concatMapAttrs mkNixosSystem (
    lib.filterAttrs (n: _: n != "default.nix") (builtins.readDir ./.)
  );
}
