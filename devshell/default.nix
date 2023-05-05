{
  self,
  inputs,
  ...
}: {
  imports = map (n: inputs.${n}.flakeModule) ["devshell" "treefmt-nix"];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays =
        map (n: inputs.${n}.overlays.default) ["colmena" "agenix"]
        ++ [self.overlays.default];
    };

    legacyPackages = pkgs;

    devshells.default.packages = with pkgs; [colmena nvfetcher agenix];

    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
      };

      settings = {
        global.excludes = ["overlays/_sources/**"];
        formatter.stylua.options = ["--config-path" "modules/shell/neovim/.stylua.toml"];
      };
    };
  };
}
