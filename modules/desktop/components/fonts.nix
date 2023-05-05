{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.fonts;
in {
  options.desktop'.components.fonts.enable = mkEnableOption "custom fonts";

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;

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
        serif = ["Roboto Slab" "Noto Serif CJK SC" "NotoSerif Nerd Font"];
        sansSerif = ["Roboto" "Sarasa Gothic SC" "NotoSans Nerd Font"];
        monospace = ["RobotoMono Nerd Font" "Noto Sans Mono CJK SC"];
        emoji = ["Noto Color Emoji"];
      };
    };

    services.xserver = {
      layout = "us";
      xkbOptions = "caps:swapescape";
      libinput.enable = true;
    };
  };
}
