{
  flake = { pkgs, ... }:
    let
      overlayPkgs = with builtins;
        attrNames
        ((readDir ../overlays/overrides) // (readDir ../overlays/packages));
      mkHydraJob = list:
        with builtins;
        listToAttrs (map (name: {
          inherit name;
          value = pkgs.${name};
        }) list);
    in {
      hydraJobs = mkHydraJob overlayPkgs
        // mkHydraJob [ "vscode-fhs" "hyprland" "colmena" ];
    };

}