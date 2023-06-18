{
  flake.overlays.default = final: prev:
    let
      inherit (final) pkgs;
      sources = final.callPackage ./_sources/generated.nix { };

      mkPackage = name:
        pkgs.callPackage ./packages/${name} { inherit sources; };

      mkOverride = name: (import ./overrides/${name} prev);

      mkOverlay = f: dir:
        with builtins;
        listToAttrs (map (name: {
          inherit name;
          value = f name;
        }) (attrNames (readDir ./${dir})));
    in (mkOverlay mkPackage "packages") // (mkOverlay mkOverride "overrides");
}
