{ config, lib, themes, ... }:
with lib;
let
  cfg = config.basics'.colors;
  palette = importJSON (themes.palette + /palette.json);
in {
  options.basics'.colors = {
    flavour = mkOption {
      type = types.enum [ "Latte" "Frappe" "Macchiato" "Mocha" ];
      default = "Mocha";
    };

    palette = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config.basics'.colors.palette = {
    inherit (palette.${toLower cfg.flavour})
      rosewater flamingo pink mauve red maroon peach yellow green teal sky
      sapphire blue lavender text subtext1 subtext0 overlay2 overlay1 overlay0
      surface2 surface1 surface0 base mantle crust;
  };
}
