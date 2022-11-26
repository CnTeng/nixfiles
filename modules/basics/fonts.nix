{ config, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      dejavu_fonts # Need for looking-glass
      # source-sans-pro
      # source-serif-pro
      # source-code-pro
      # source-han-sans
      # source-han-serif
      # source-han-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      roboto
      roboto-slab
      roboto-mono
      (nerdfonts.override {
        fonts = [ "FiraCode" "RobotoMono" ];
      })
    ] ++ (with config;[
      nur.repos.rewine.ttf-ms-win10
    ]);
    fontconfig = {
      defaultFonts = {
        serif = [
          # "Source Serif"
          # "Source Han Serif SC"
          "Roboto Slab"
          "Noto Serif CJK SC"
        ];
        sansSerif = [
          # "Source Sans"
          # "Source Han Sans SC"
          "Roboto"
          "Noto Sans CJK SC"
        ];
        monospace = [
          # "Source Code Pro"
          # "Source Han Mono SC"
          "Roboto Mono"
          "Noto Sans Mono CJK SC"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:swapescape";
    libinput.enable = true;
  };
}
