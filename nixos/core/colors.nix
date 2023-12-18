{ config, lib, themes, ... }:
with lib;
let
  cfg = config.core'.colors;
  palette = importJSON (themes.palette + /palette.json);
in {
  options.core'.colors = {
    flavour = mkOption {
      default = "Mocha";
      type = types.enum [ "Latte" "Frappe" "Macchiato" "Mocha" ];
      visible = false;
    };

    palette = mkOption {
      default = { };
      type = types.attrs;
      visible = false;
    };
  };

  config.core'.colors.palette = {
    inherit (palette.${toLower cfg.flavour})
      rosewater flamingo pink mauve red maroon peach yellow green teal sky
      sapphire blue lavender text subtext1 subtext0 overlay2 overlay1 overlay0
      surface2 surface1 surface0 base mantle crust;
  };
}
