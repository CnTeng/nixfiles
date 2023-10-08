{inputs, ...}: {
  imports = [inputs.pre-commit.flakeModule];

  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    pre-commit.settings.hooks.trufflehog = {
      enable = true;
      entry =
        lib.getExe' pkgs.trufflehog "trufflehog"
        + " git file://."
        + " --no-update"
        + " --since-commit HEAD"
        + " --only-verified"
        + " --fail";
      stages = ["commit" "push"];
      pass_filenames = false;
    };
  };
}
