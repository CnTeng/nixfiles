{withSystem, ...}: {
  flake = withSystem "x86_64-linux" ({pkgs, ...}: let
    mkHydraJob = list:
      with builtins;
        listToAttrs (map (name: {
            inherit name;
            value = pkgs.${name};
          })
          list);
  in {
    hydraJobs = {
      x86_64-linux = mkHydraJob ["colmena" "nvfetcher" "hyprland"];
    };
  });
}
