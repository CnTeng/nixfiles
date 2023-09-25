{withSystem, ...}: {
  flake = let
    mkHydraJob = system: list:
      with builtins;
        listToAttrs (map (name: {
            inherit name;
            value = withSystem system ({pkgs, ...}: pkgs.${name});
          })
          list);
  in {
    hydraJobs = {
      x86_64-linux = mkHydraJob "x86_64-linux" ["colmena" "nvfetcher" "caddy" "hyprland"];
      aarch64-linux = mkHydraJob "aarch64-linux" ["colmena" "nvfetcher" "caddy"];
    };
  };
}
