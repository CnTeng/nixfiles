{inputs, ...}: {
  imports = [inputs.treefmt.flakeModule];

  perSystem = {...}: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
      };
      settings.formatter = {
        alejandra.excludes = ["overlays/_sources/*"];
        prettier.excludes = [
          "overlays/_sources/*"
          "secrets.yaml"
          "tfstate.yaml"
        ];
      };
    };
  };
}
