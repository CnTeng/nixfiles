{ ... }:

let
  colorScheme = import ../../desktop/modules/colorscheme.nix;
in
{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
    colors = [
      "${colorScheme.base00}"
      "${colorScheme.base01}"
      "${colorScheme.base02}"
      "${colorScheme.base03}"
      "${colorScheme.base04}"
      "${colorScheme.base05}"
      "${colorScheme.base06}"
      "${colorScheme.base07}"
      "${colorScheme.base08}"
      "${colorScheme.base09}"
      "${colorScheme.base0A}"
      "${colorScheme.base0B}"
      "${colorScheme.base0C}"
      "${colorScheme.base0D}"
      "${colorScheme.base0E}"
      "${colorScheme.base0F}"
    ];
  };
}
