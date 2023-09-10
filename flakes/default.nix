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
        [self.overlays.default]
        ++ map (n: inputs.${n}.overlays.default) ["colmena" "nvfetcher"];
    };

    legacyPackages = pkgs;
  };
}
