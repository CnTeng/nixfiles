final: prev:
let
  callLibs = file: import file { lib = final; };

  helper = callLibs ./helper.nix;
  options = callLibs ./options.nix;
in
{
  inherit (helper)
    importModule
    mkKnownHosts
    mkMatchBlocks
    mkBuildMachines
    ;

  inherit (options) mkEnableOption';
}
