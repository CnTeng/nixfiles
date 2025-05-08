{ inputs, self, ... }:
{
  flake.overlays.lib =
    final: prev:
    let
      callLibs = file: import file { lib = final; };

      helper = callLibs ./helper.nix;
      options = callLibs ./options.nix;
    in
    {
      inherit (helper)
        importModule
        removeHashTag
        ;

      inherit (options) mkEnableOption';
    };

  perSystem = {
    _module.args.lib = inputs.nixpkgs.lib.extend self.overlays.lib;
  };
}
