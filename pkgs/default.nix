{ inputs, self, ... }:
{
  flake =
    { lib, ... }:
    {
      overlays.default =
        final: prev:
        lib.packagesFromDirectoryRecursive {
          callPackage = lib.callPackageWith (prev.pkgs // { prev = prev; });
          directory = ./.;
        };
    };

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ self.overlays.default ];
        };
      };

      legacyPackages = pkgs;
    };
}
