final: prev:
let
  callLibs = file: import file { lib = final; };

  modules = callLibs ./modules.nix;
  trivial = callLibs ./trivial.nix;
in {
  inherit (modules) importModule;
  inherit (trivial) removeHashTag toDec toRgb;
}
