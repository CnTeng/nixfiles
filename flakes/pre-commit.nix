{ inputs, ... }:
{
  imports = [ inputs.pre-commit.flakeModule ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      pre-commit.settings.hooks = {
        commitizen.enable = true;
        treefmt.enable = true;
        trufflehog = {
          enable = true;
          entry =
            lib.getExe' pkgs.trufflehog "trufflehog"
            + " git file://."
            + " --no-update"
            + " --since-commit HEAD"
            + " --only-verified"
            + " --fail";
          pass_filenames = false;
        };
      };
    };
}
