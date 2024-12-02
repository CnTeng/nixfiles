{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.fonts;
in
{
  options.desktop'.fonts.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.fira-code
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
        "FiraCode Nerd Font"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
        "FiraCode Nerd Font"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "FiraCode Nerd Font"
      ];
    };

    fonts.fontDir.enable = true;
  };
}
