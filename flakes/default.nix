{
  inputs,
  self,
  ...
}: {
  imports = [./devshell.nix ./hydra.nix ./treefmt.nix];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays =
        [self.overlays.default]
        ++ map (n: inputs.${n}.overlays.default) [
          "colmena"
          "nvfetcher"
          "hyprland"
        ];
    };

    legacyPackages = pkgs;
  };
}
