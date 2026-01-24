{
  self,
  inputs,
  lib,
  ...
}:
let
  data = lib.importJSON ../infra/outputs/data.json;

  mkNixosSystem = host: _: {
    ${host} = lib.nixosSystem {
      specialArgs = { inherit inputs; };
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
            hostInfo = data.hosts.${host};
            stateVersion = "25.11";
          };
        }
        self.nixosModules.default
        ./${host}
      ];
    };
  };
in
lib.pipe (builtins.readDir ./.) [
  (lib.filterAttrs (n: _: n != "default.nix"))
  (lib.concatMapAttrs mkNixosSystem)
]
