{ pkgs, user, ... }:

let
  # Catppuccin Macchiato
  # Copy from https://github.com/catppuccin/catppuccin
  base00 = "24273a"; # base
  base01 = "1e2030"; # mantle
  base02 = "363a4f"; # surface0
  base03 = "494d64"; # surface1
  base04 = "5b6078"; # surface2
  base05 = "cad3f5"; # text
  base06 = "f4dbd6"; # rosewater
  base07 = "b7bdf8"; # lavender
  base08 = "ed8796"; # red
  base09 = "f5a97f"; # peach
  base0A = "eed49f"; # yellow
  base0B = "a6da95"; # green
  base0C = "8bd5ca"; # teal
  base0D = "8aadf4"; # blue
  base0E = "c6a0f6"; # mauve
  base0F = "f0c6c6"; # flamingo
in
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  home-manager.users.${user} = {
    # Copy from https://github.com/catppuccin/fcitx5
    xdg.dataFile."fcitx5/themes/catppuccin/theme.conf".text = ''
      [Metadata]
      Name=Catppuccin Macchiato
      Version=0.2
      Author=justTOBBI and Isabelinc
      Description=Catppuccin Macchiato Color Theme (Dark)
      ScaleWithDPI=True

      [InputPanel]
      Font=Sans 13
      # Blue
      NormalColor=#${base0D}
      # Peach
      HighlightCandidateColor=#${base09}
      #Peach
      HighlightColor=#${base09}
      # Surface0
      HighlightBackgroundColor=#${base02}
      Spacing=3

      [InputPanel/TextMargin]
      Left=10
      Right=10
      Top=6
      Bottom=6

      [InputPanel/Background]
      # Surface0
      Color=#${base02}
      # Surface0
      BorderColor=#${base02}
      BorderWidth=2

      [InputPanel/Background/Margin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [InputPanel/Highlight]
      # Surface0
      Color=#${base02}

      [InputPanel/Highlight/Margin]
      Left=10
      Right=10
      Top=7
      Bottom=7

      [Menu]
      Font=Sans 10
      # Text
      NormalColor=#${base05}
      Spacing=3

      [Menu/Background]
      # Surface0
      Color=#${base02}

      [Menu/Background/Margin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [Menu/ContentMargin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [Menu/Highlight]
      # Peach
      Color=#${base09}

      [Menu/Highlight/Margin]
      Left=10
      Right=10
      Top=5
      Bottom=5

      [Menu/Separator]
      # Base
      Color=#${base00}

      [Menu/CheckBox]
      # Image=radio.png

      [Menu/SubMenu]
      # Image=arrow.png

      [Menu/TextMargin]
      Left=5
      Right=5
      Top=5
      Bottom=5
    '';
  };
}
