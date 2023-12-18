{ config, lib, ... }:
with lib;
let
  cfg = config.desktop'.profiles.console;
  inherit (config.core'.colors) palette;
in {
  options.desktop'.profiles.console.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    console = {
      colors = with palette;
        map removeHashTag [
          base.hex
          mantle.hex
          surface0.hex
          surface1.hex
          surface2.hex
          text.hex
          rosewater.hex
          lavender.hex
          red.hex
          peach.hex
          yellow.hex
          green.hex
          teal.hex
          blue.hex
          mauve.hex
          flamingo.hex
        ];
      useXkbConfig = true;
    };
  };
}
