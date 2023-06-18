{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.basics'.console;
  inherit (config.basics') colorScheme;
in {
  options.basics'.console.enable = mkEnableOption "console config" // {
    default = true;
  };

  config = mkIf cfg.enable {
    console = {
      useXkbConfig = true;
      font = "ter-v20b";
      # Copy from https://github.com/catppuccin/base16
      colors = with colorScheme; [
        "${base}"
        "${mantle}"
        "${surface0}"
        "${surface1}"
        "${surface2}"
        "${text}"
        "${rosewater}"
        "${lavender}"
        "${red}"
        "${peach}"
        "${yellow}"
        "${green}"
        "${teal}"
        "${blue}"
        "${mauve}"
        "${flamingo}"
      ];
      packages = [ pkgs.terminus_font ];
    };
  };
}
