{ inputs, ... }:
{
  imports = [ inputs.treefmt.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          nixfmt-rfc-style.enable = true;
          prettier.enable = true;
          terraform.enable = true;
        };

        settings.formatter = {
          nixfmt-rfc-style.excludes = [ "pkgs/_sources/*" ];
          prettier.excludes = [ "pkgs/_sources/*" ];
        };
      };
    };
}
