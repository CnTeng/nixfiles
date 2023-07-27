{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.console;
  inherit (config.desktop'.profiles) palette;
in {
  options.desktop'.profiles.console.enable =
    mkEnableOption "console config";

  config = mkIf cfg.enable {
    console = {
      useXkbConfig = true;
      font = "ter-v20b";
      colors = with palette;
        map removeHashTag [
          "${base.hex}"
          "${mantle.hex}"
          "${surface0.hex}"
          "${surface1.hex}"
          "${surface2.hex}"
          "${text.hex}"
          "${rosewater.hex}"
          "${lavender.hex}"
          "${red.hex}"
          "${peach.hex}"
          "${yellow.hex}"
          "${green.hex}"
          "${teal.hex}"
          "${blue.hex}"
          "${mauve.hex}"
          "${flamingo.hex}"
        ];
      packages = [pkgs.terminus_font];
    };
  };
}
