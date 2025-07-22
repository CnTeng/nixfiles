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
  options.desktop'.fonts.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      adwaita-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.fira-code
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = [
        "Adwaita Mono"
        "Noto Sans Mono CJK SC"
        "FiraCode Nerd Font"
      ];
      sansSerif = [
        "Adwaita Sans"
        "Noto Sans CJK SC"
        "FiraCode Nerd Font"
      ];
      serif = [
        "Noto Serif CJK SC"
        "FiraCode Nerd Font"
      ];
    };

    fonts.fontDir.enable = true;
  };
}
