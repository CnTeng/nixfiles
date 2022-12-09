{ ... }:

let
  # Catppuccin Macchiato
  # Copy from https://github.com/catppuccin/catppuccin
  base00 = "24273a"; # base
  base01 = "1e2030"; # mantle
  base02 = "363a4f"; # surface0
  base03 = "494d64"; # surface1
  base04 = "5b6078"; # surface2
  base05 = "cad3f5"; # text
  base06 = "f4dbd6"; # rosewater
  base07 = "b7bdf8"; # lavender
  base08 = "ed8796"; # red
  base09 = "f5a97f"; # peach
  base0A = "eed49f"; # yellow
  base0B = "a6da95"; # green
  base0C = "8bd5ca"; # teal
  base0D = "8aadf4"; # blue
  base0E = "c6a0f6"; # mauve
  base0F = "f0c6c6"; # flamingo
in
{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
    colors = [
      "${base00}"
      "${base01}"
      "${base02}"
      "${base03}"
      "${base04}"
      "${base05}"
      "${base06}"
      "${base07}"
      "${base08}"
      "${base09}"
      "${base0A}"
      "${base0B}"
      "${base0C}"
      "${base0D}"
      "${base0E}"
      "${base0F}"
    ];
  };
}
