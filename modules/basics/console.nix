{ config, lib, ... }:

with lib;

let
  cfg = config.custom.basics.console;
  inherit (config.custom) colorScheme;
in {
  options.custom.basics.console = {
    enable = mkEnableOption "console config" // { default = true; };
  };

  config = mkIf cfg.enable {
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
      earlySetup = true;
    };
  };
}
