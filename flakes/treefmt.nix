{ inputs, ... }:
{
  imports = [ inputs.treefmt.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
        taplo.enable = true;
        terraform.enable = true;
      };
    };
  };
}
