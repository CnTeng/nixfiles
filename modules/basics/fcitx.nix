{ pkgs, user, ... }:

let
  colorScheme = import ../desktop/modules/colorscheme.nix;
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
      NormalColor=#${colorScheme.base0D}
      # Peach
      HighlightCandidateColor=#${colorScheme.base09}
      #Peach
      HighlightColor=#${colorScheme.base09}
      # Surface0
      HighlightBackgroundColor=#${colorScheme.base02}
      Spacing=3

      [InputPanel/TextMargin]
      Left=10
      Right=10
      Top=6
      Bottom=6

      [InputPanel/Background]
      # Surface0
      Color=#${colorScheme.base02}
      # Surface0
      BorderColor=#${colorScheme.base02}
      BorderWidth=2

      [InputPanel/Background/Margin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [InputPanel/Highlight]
      # Surface0
      Color=#${colorScheme.base02}

      [InputPanel/Highlight/Margin]
      Left=10
      Right=10
      Top=7
      Bottom=7

      [Menu]
      Font=Sans 10
      # Text
      NormalColor=#${colorScheme.base05}
      Spacing=3

      [Menu/Background]
      # Surface0
      Color=#${colorScheme.base02}

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
      Color=#${colorScheme.base09}

      [Menu/Highlight/Margin]
      Left=10
      Right=10
      Top=5
      Bottom=5

      [Menu/Separator]
      # colorScheme.base
      Color=#${colorScheme.base00}

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
