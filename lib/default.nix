final: prev: let
  callLibs = file: import file {lib = final;};

  modules = callLibs ./modules.nix;
  trivial = callLibs ./trivial.nix;
  hyprland = callLibs ./hyprland.nix;
in {
  inherit (modules) importModule;
  inherit (trivial) removeHashTag toDec toRgb;
  inherit (hyprland) mkKeymap mkSubmap getExe' mkOpacity mkFloat mkBlurls mkSectionStr;
}
