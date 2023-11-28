{ inputs, ... }: {
  imports = [ inputs.pre-commit.flakeModule ];

  perSystem = { config, lib, pkgs, ... }: {
    pre-commit.settings.hooks = {
      commitizen.enable = true;
      treefmt.enable = true;
      trufflehog = {
        enable = true;
        entry = lib.getExe' pkgs.trufflehog "trufflehog" + " git file://."
          + " --no-update" + " --since-commit HEAD" + " --only-verified"
          + " --fail";
        # stages = ["commit" "push"];
        pass_filenames = false;
      };
    };

    devshells.default.devshell.startup = {
      pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
