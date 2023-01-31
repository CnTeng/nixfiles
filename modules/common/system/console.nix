{ ... }:

let
  colorScheme = import ../../desktop/modules/colorscheme.nix;
in
{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
    # Copy from https://github.com/catppuccin/base16
    colors = [
      "${colorScheme.base}"
      "${colorScheme.mantle}"
      "${colorScheme.surface0}"
      "${colorScheme.surface1}"
      "${colorScheme.surface2}"
      "${colorScheme.text}"
      "${colorScheme.rosewater}"
      "${colorScheme.lavender}"
      "${colorScheme.red}"
      "${colorScheme.peach}"
      "${colorScheme.yellow}"
      "${colorScheme.green}"
      "${colorScheme.teal}"
      "${colorScheme.blue}"
      "${colorScheme.mauve}"
      "${colorScheme.flamingo}"
    ];
  };
}
