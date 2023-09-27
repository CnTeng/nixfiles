{withSystem, ...}: {
  flake.hydraJobs = let
    common = p: {
      colmena = p.colmena;
      nvfetcher = p.nvfetcher;
      caddy = p.caddy;
      naive = p.naive;
      wsl-notify-send = p.wsl-notify-send;
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
