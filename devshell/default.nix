{ self, inputs, ... }: {
  imports = map (n: inputs.${n}.flakeModule) [ "devshell" "treefmt-nix" ];

  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ]
        ++ map (n: inputs.${n}.overlays.default) [ "colmena" "agenix" ];
    };

    legacyPackages = pkgs;

    devshells.default.packages = with pkgs; [ colmena nvfetcher agenix ];

    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
      };
    };
  };
}
