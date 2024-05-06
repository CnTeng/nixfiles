{ inputs, ... }:
{
  imports = [ inputs.treefmt.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          prettier.enable = true;
          terraform.enable = true;
        };

        settings.formatter = {
          nixfmt.excludes = [ "pkgs/_sources/*" ];
          prettier.excludes = [ "pkgs/_sources/*" ];
        };
      };
    };
}
