{
  inputs,
  self,
  ...
}: {
  imports = [./devshell.nix ./treefmt.nix ./pre-commit.nix];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        self.overlays.default
        inputs.colmena.overlay
      ];
    };

    legacyPackages = pkgs;
  };
}
