final: prev:
let
  callLibs = file: import file { lib = final; };

  modules = callLibs ./modules.nix;
  options = callLibs ./options.nix;
  trivial = callLibs ./trivial.nix;
in {
  inherit (modules) importModule;
  inherit (options) mkEnableOption';
  inherit (trivial) removeHashTag toRgb toRgb';
}
