{withSystem, ...}: {
  flake.hydraJobs = let
    common = p: {
      colmena = p.colmena;
      caddy = p.caddy;
      naive = p.naive;
    };

    desktop = p: {
      hyprland = p.hyprland;
      waybar = p.waybar;
      nemo = p.cinnamon.nemo-with-extensions;
    };
  in {
    aarch64-linux = withSystem "aarch64-linux" ({pkgs, ...}: common pkgs);
    x86_64-linux = withSystem "x86_64-linux" ({pkgs, ...}: common pkgs // desktop pkgs);
  };
}
