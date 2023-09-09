{
  inputs,
  self,
  ...
}: {
  imports = [./devshell.nix ./treefmt.nix];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays =
        map (n: inputs.${n}.overlays.default) ["colmena" "nvfetcher"]
        ++ [self.overlays.default];
    };

    legacyPackages = pkgs;
  };
}
