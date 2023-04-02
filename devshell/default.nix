{ inputs, ... }: {
  imports = with inputs; [ devshell.flakeModule treefmt-nix.flakeModule ];

  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.colmena.overlay ];
    };

    devshells.default.packages = with pkgs; [ colmena nvfetcher agenix ];

    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
      };

      settings = {
        global.excludes = [ "overlays/_sources/**" ];
        formatter.stylua.options =
          [ "--config-path" "modules/shell/neovim/.stylua.toml" ];
      };
    };
  };
}
