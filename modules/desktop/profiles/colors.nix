{lib, ...}:
with lib; {
  options.desktop'.profiles.colorScheme = mkOption {
    type = types.attrs;
    default = {};
    description = mkDoc ''
      Set the colorscheme
    '';
  };

  config.desktop'.profiles.colorScheme = {
    # Catppuccin Macchiato
    # Copy from https://github.com/catppuccin/catppuccin
    # crust = "#181926";
    # mantle = "#1e2030";
    # base = "#24273a";
    # surface0 = "#363a4f";
    # surface1 = "#494d64";
    # surface2 = "#5b6078";
    # overlay0 = "#6e738d";
    # overlay1 = "#8087a2";
    # overlay2 = "#939ab7";
    # subtext0 = "#a5adcb";
    # subtext1 = "#b8c0e0";
    # text = "#cad3f5";
    # lavender = "#b7bdf8";
    # blue = "#8aadf4";
    # sapphire = "#7dc4e4";
    # sky = "#91d7e3";
    # teal = "#8bd5ca";
    # green = "#a6da95";
    # yellow = "#eed49f";
    # peach = "#f5a97f";
    # maroon = "#ee99a0";
    # red = "#ed8796";
    # mauve = "#c6a0f6";
    # pink = "#f5bde6";
    # flamingo = "#f0c6c6";
    # rosewater = "#f4dbd6";

    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
}
