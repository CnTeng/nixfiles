{
  flake.overlays.default = final: prev:
    let
      inherit (final) pkgs;
      sources = import ./_sources/generated.nix {
        inherit (final) fetchurl fetchgit fetchFromGitHub dockerTools;
      };

      mkPackage = name:
        pkgs.callPackage ./packages/${name} { inherit sources; };
      mkOverride = name:
        prev.${name}.overrideAttrs (import ./overrides/${name} pkgs);

      mkOverlay = f: dir:
        with builtins;
        listToAttrs (map (name: {
          inherit name;
          value = f name;
        }) (attrNames (readDir ./${dir})));
    in (mkOverlay mkPackage "packages") // (mkOverlay mkOverride "overrides");
}
