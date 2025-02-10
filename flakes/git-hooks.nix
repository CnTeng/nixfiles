{ inputs, ... }:
{
  imports = [ inputs.git-hooks-nix.flakeModule ];

  perSystem = {
    pre-commit.settings.hooks = {
      commitizen.enable = true;
      treefmt.enable = true;
    };
  };
}
