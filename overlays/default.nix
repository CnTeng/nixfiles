{
  flake.overlays = {
    lib = import ./lib;

    default = final: prev:
      let
        inherit (final) pkgs;
        sources = final.callPackage ./_sources/generated.nix { };

        mkPackage = dir: name:
          pkgs.callPackage ./${dir}/${name} { source = sources.${name}; };

        mkOverride = dir: name: (import ./${dir}/${name} prev);

        mkOverlay = f: dir:
          with builtins;
          listToAttrs (map (name: {
            inherit name;
            value = f dir name;
          }) (attrNames (readDir ./${dir})));
      in (mkOverlay mkPackage "packages") // (mkOverlay mkOverride "overrides");
  };
}
