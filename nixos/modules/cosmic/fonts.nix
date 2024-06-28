{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cosmic.profiles.fonts;
in
{
  options.cosmic.profiles.fonts.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (nerdfonts.override {
        fonts = [
          "Noto"
          "FiraCode"
        ];
      })
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [
        "NotoMono Nerd Font"
        "Noto Sans Mono CJK SC"
      ];
      sansSerif = [
        "NotoSans Nerd Font"
        "Noto Sans CJK SC"
      ];
      serif = [
        "NotoSerif Nerd Font"
        "Noto Serif CJK SC"
      ];
    };

    fonts.fontDir.enable = true;
  };
}
