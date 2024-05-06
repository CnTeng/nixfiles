final: prev:
let
  callLibs = file: import file { lib = final; };

  helper = callLibs ./helper.nix;
  options = callLibs ./options.nix;
  trivial = callLibs ./trivial.nix;
in
{
  inherit (helper) importModule;
  inherit (options) mkEnableOption';
  inherit (trivial) removeHashTag;
}
