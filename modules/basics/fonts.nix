{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      # source-han-sans
      # source-han-serif
      # source-han-mono
      # source-sans-pro
      # source-serif-pro
      # source-code-pro
      roboto
      roboto-slab
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      wqy_zenhei
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "RobotoMono"
          "Noto"
        ];
      })
    ] ++ (with config;[
      nur.repos.rewine.ttf-ms-win10
    ]);

    fontconfig.defaultFonts = {
      serif = [
        # "Source Serif"
        # "Source Han Serif SC"
        "Roboto Slab"
        "Noto Serif CJK SC"
        "NotoSerif Nerd Font"
      ];
      sansSerif = [
        # "Source Sans"
        # "Source Han Sans SC"
        "Roboto"
        "Noto Sans CJK SC"
        "NotoSans Nerd Font"
      ];
      monospace = [
        # "Source Code Pro"
        # "Source Han Mono SC"
        "RobotoMono Nerd Font"
        "Noto Sans Mono CJK SC"

      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:swapescape";
    libinput.enable = true;
  };
}
