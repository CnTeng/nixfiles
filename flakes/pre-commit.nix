{ inputs, ... }:
{
  imports = [ inputs.pre-commit.flakeModule ];

  perSystem = {
    pre-commit.settings.hooks = {
      commitizen.enable = true;
      treefmt.enable = true;
    };
  };
}
