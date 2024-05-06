{ inputs, self, ... }:
{
  flake.overlays = {
    lib = import ./lib;

    default =
      final: prev:
      let
        sources = final.callPackage ./_sources/generated.nix { };

        mkPackage = n: final.callPackage ./packages/${n} { source = sources.${n}; };
        mkOverride = n: (import ./overrides/${n} prev sources.${n});
        mkOverlay = f: dir: with builtins; mapAttrs (n: _: f n) (readDir dir);
      in
      (mkOverlay mkPackage ./packages) // (mkOverlay mkOverride ./overrides);
  };

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.default
            inputs.colmena.overlays.default
            inputs.rx-nvim.overlays.default
          ];
        };
        lib = pkgs.lib.extend self.overlays.lib;
      };

      legacyPackages = pkgs;
    };
}
