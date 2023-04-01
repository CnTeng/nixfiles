{ lib, ... }:
with lib; {
  options.basics'.colorScheme = mapAttrs (name: color:
    mkOption {
      type = types.str;
      default = color;
      description = mkDoc ''
        Set the ${name} of color scheme
      '';
    }) {
      # Catppuccin Macchiato
      # Copy from https://github.com/catppuccin/catppuccin
      crust = "181926";
      mantle = "1e2030";
      base = "24273a";
      surface0 = "363a4f";
      surface1 = "494d64";
      surface2 = "5b6078";
      overlay0 = "6e738d";
      overlay1 = "8087a2";
      overlay2 = "939ab7";
      subtext0 = "a5adcb";
      subtext1 = "b8c0e0";
      text = "cad3f5";
      lavender = "b7bdf8";
      blue = "8aadf4";
      sapphire = "7dc4e4";
      sky = "91d7e3";
      teal = "8bd5ca";
      green = "a6da95";
      yellow = "eed49f";
      peach = "f5a97f";
      maroon = "ee99a0";
      red = "ed8796";
      mauve = "c6a0f6";
      pink = "f5bde6";
      flamingo = "f0c6c6";
      rosewater = "f4dbd6";
    };
}
