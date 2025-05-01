{
  inputs,
  lib,
  self,
  withSystem,
  ...
}:
let
  data = lib.importJSON ../infra/outputs/data.json;
  user = "yufei";

  mkNixosSystem =
    host:
    let
      inherit (data.hosts.${host}) system;
    in
    withSystem system (
      { pkgs, lib, ... }:
      lib.nixosSystem {
        pkgs = pkgs;
        specialArgs = {
          inherit inputs data user;
        };
        modules = [
          {
            networking.hostName = host;
            nixpkgs.hostPlatform = system;

            system.stateVersion = "24.11";
          }
          self.nixosModules.default
          ./${host}
        ];
      }
    );
in
{
  flake.nixosConfigurations = {
    rxtp = mkNixosSystem "rxtp";
    hcde = mkNixosSystem "hcde";
    lssg = mkNixosSystem "lssg";
    rxrk = mkNixosSystem "rxrk";
  };
}
