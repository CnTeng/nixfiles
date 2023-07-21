{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.fonts;
in {
  options.desktop'.profiles.fonts.enable = mkEnableOption "fonts component";

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs; [
        roboto
        roboto-slab
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        sarasa-gothic
        (nerdfonts.override {fonts = ["FiraCode" "RobotoMono" "Noto"];})
        ttf-ms-win10
        ttf-wps-fonts
      ];

      fontconfig.defaultFonts = {
        monospace = ["RobotoMono Nerd Font" "Noto Sans Mono CJK SC"];
        sansSerif = ["Roboto" "Sarasa Gothic SC" "NotoSans Nerd Font"];
        serif = ["Roboto Slab" "Noto Serif CJK SC" "NotoSerif Nerd Font"];
        emoji = ["Noto Color Emoji"];
      };

      fontDir.enable = true;
    };
  };
}
