{withSystem, ...}: {
  flake.hydraJobs = let
    mkHydraJob = system: list:
      with builtins;
        listToAttrs (map (name: {
            inherit name;
            value = withSystem system ({pkgs, ...}: pkgs.${name});
          })
          list);

    common = ["colmena" "nvfetcher" "caddy" "naive"];
    desktop = ["hyprland" "waybar"];
  in {
    aarch64-linux = mkHydraJob "aarch64-linux" common;
    x86_64-linux = mkHydraJob "x86_64-linux" (common ++ desktop);
  };
}
