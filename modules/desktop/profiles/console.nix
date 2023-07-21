{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.console;
  inherit (config.desktop'.profiles) colorScheme;
in {
  options.desktop'.profiles.console.enable =
    mkEnableOption "console config"
    // {default = true;};

  config = mkIf cfg.enable {
    console = {
      useXkbConfig = true;
      font = "ter-v20b";
      colors = with colorScheme;
        map removeHashTag [
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
      packages = [pkgs.terminus_font];
    };
  };
}
