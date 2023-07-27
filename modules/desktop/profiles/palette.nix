{
  lib,
  sources,
  config,
  ...
}:
with lib; let
  inherit (config.basics'.colors) flavour;

  catppuccin = importJSON (sources.catppuccin-palette.src + /palette.json);
in {
  options.desktop'.profiles.palette = mkOption {
    type = types.attrs;
    default = {};
  };

  config.desktop'.profiles.palette = {
    inherit
      (catppuccin.${toLower flavour})
      rosewater
      flamingo
      pink
      mauve
      red
      maroon
      peach
      yellow
      green
      teal
      sky
      sapphire
      blue
      lavender
      text
      subtext1
      subtext0
      overlay2
      overlay1
      overlay0
      surface2
      surface1
      surface0
      base
      mantle
      crust
      ;
  };
}
